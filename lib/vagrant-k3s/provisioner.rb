# frozen_string_literal: false

require 'multi_json/convertible_hash_keys'
require 'vagrant'
require 'vagrant/errors'
require 'yaml'

module VagrantPlugins
  module K3s
    class Provisioner < Vagrant.plugin('2', :provisioner)
      include MultiJson::ConvertibleHashKeys
      def initialize(machine,config)
        super(machine,config)
        @logger = Log4r::Logger.new("vagrant::provisioners::k3s")
      end

      def configure(root_config)
        @logger.debug root_config.inspect
      end

      def cleanup
      end

      def provision
        args = ""
        if config.args.is_a?(String)
          args = " #{config.args.to_s}"
        elsif config.args.is_a?(Array)
          args = config.args.map { |a| quote_and_escape(a) }
          args = " #{args.join(" ")}"
        end

        @machine.ui.info 'Installing K3s ...'

        unless @machine.guest.capability(:curl_installed)
          @machine.guest.capability(:curl_install)
        end

        config_file = config.config_path.to_s
        config_yaml = config.config.is_a?(String) ? config.config : stringify_keys(config.config).to_yaml
        with_file_upload "k3s-config.yaml".freeze, config_file, config_yaml

        install_env_file = config.env_path.to_s
        install_env_text = ""
        if config.env.is_a?(String)
          install_env_text = config.env.to_s
        end
        if config.env.is_a?(Array)
          config.env.each {|line| install_env_text << "#{line.to_s}\n"}
        end
        if config.env.is_a?(Hash)
          config.env.each {|key,value| install_env_text << "#{key.to_s}=#{quote_and_escape(value.to_s)}\n"}
        end
        with_file_upload "k3s-install.env".freeze, install_env_file, install_env_text

        install_sh = "/tmp/vagrant-k3s-provisioner-install.sh".freeze
        with_file_upload "k3s-install.sh", install_sh, <<~EOF
          #/usr/bin/env bash
          set -eu -o pipefail
          mkdir -m 0755 -p $(dirname #{config.config_path}) $(dirname #{config.env_path})
          chown #{config.config_owner} #{config.config_path}
          chmod #{config.config_mode} #{config.config_path}
          chown #{config.env_owner} #{config.env_path}
          chmod #{config.env_mode} #{config.env_path}
          set -o allexport
          source #{config.env_path}
          set +o allexport
          curl -fsL #{config.installer_url} | sh -s - #{args}
        EOF
        outputs, handler = build_outputs
        begin
          @machine.communicate.sudo("chmod +x #{install_sh} && #{install_sh}", error_key: :ssh_bad_exit_status_muted, &handler)
        ensure
          outputs.values.map(&:close)
        end

        begin
          exe = "k3s"
          @machine.ui.info 'Checking the K3s version ...'
          @machine.communicate.execute("which k3s", :error_key => :ssh_bad_exit_status_muted) do |type, data|
            exe = data.chomp if type == :stdout
          end
        rescue Vagrant::Errors::VagrantError => e
          @machine.ui.detail "#{e.extra_data[:stderr].chomp}", :color => :red
        else
          outputs, handler = build_outputs
          begin
            @machine.communicate.execute("#{exe} --version", :error_key => :ssh_bad_exit_status_muted, &handler)
          ensure
            outputs.values.map(&:close)
          end
        end
      end

      def build_outputs
        outputs = {
          stdout: Vagrant::Util::LineBuffer.new { |line| handle_comm(:stdout, line) },
          stderr: Vagrant::Util::LineBuffer.new { |line| handle_comm(:stderr, line) },
        }
        block = proc { |type, data|
          outputs[type] << data if outputs[type]
        }
        [outputs, block]
      end

      # This handles outputting the communication line back to the UI
      def handle_comm(type, data)
        if [:stderr, :stdout].include?(type)
          # Output the line with the proper color based on the stream.
          options = {}
          options[:color] = type == :stdout ? :green : :red

          @machine.ui.detail(data.chomp, **options)
        end
      end

      def with_file(name='vagrant-k3s-provisioner', content)
        file = Tempfile.new([name])
        file.binmode
        begin
          file.write(content)
          file.fsync
          file.close
          yield file.path
        ensure
          file.close
          file.unlink
        end
      end

      def with_file_upload(name='vagrant-k3s-provisioner', to, content)
        with_file(name, content) do |from|
          tmpdir = @machine.guest.capability :create_tmp_path, {:type => :directory}
          tmpfile = [tmpdir, File.basename(to)].join('/')
          @machine.communicate.upload(from, tmpfile)
          @machine.communicate.sudo("mkdir -m 0755 -p #{File.dirname(to)} && mv -f #{tmpfile} #{to}")
        end
        to
      end

      def quote_and_escape(text, quote = '"')
        "#{quote}#{text.to_s.gsub(/#{quote}/) { |m| "#{m}\\#{m}#{m}" }}#{quote}"
      end
    end
  end
end
