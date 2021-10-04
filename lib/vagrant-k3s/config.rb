# frozen_string_literal: true

module VagrantPlugins
  module K3s
    class Config < Vagrant.plugin(2, :config)
      DEFAULT_CONFIG_PATH = "/etc/rancher/k3s/conf.yaml".freeze
      DEFAULT_ENV_PATH = "/etc/rancher/k3s/install.env".freeze
      DEFAULT_INSTALLER_URL = "https://get.k3s.io".freeze

      # string or array
      # @return [Array<String]
      attr_accessor :args

      # string (.yaml) or hash
      # @return [Hash]
      attr_accessor :config

      # Defaults to `/etc/rancher/k3s/conf.yaml`
      # @return [String]
      attr_accessor :config_path

      # string (.env), array, or hash
      # @return [Array<String>]
      attr_accessor :env

      # Defaults to `/etc/rancher/k3s/install.env`
      # @return [String]
      attr_accessor :env_path

      # Defaults to `https://get.k3s.io`
      # @return [String]
      attr_accessor :installer_url

      # # INSTALL_K3S_BIN_DIR
      # # @return [String]
      # attr_accessor :install_bin_dir
      #
      # # INSTALL_K3S_BIN_DIR_READ_ONLY
      # # @return [Boolean]
      # attr_accessor :install_bin_dir_ro
      #
      # # INSTALL_K3S_CHANNEL
      # # @return [String]
      # attr_accessor :install_channel
      #
      # # INSTALL_K3S_CHANNEL_URL
      # # @return [String]
      # attr_accessor :install_channel_url
      #
      # # INSTALL_K3S_COMMIT
      # # @return [String]
      # attr_accessor :install_commit
      #
      # # INSTALL_K3S_EXEC
      # # @return [String]
      # attr_accessor :install_exec
      #
      # # INSTALL_K3S_NAME
      # # @return [String]
      # attr_accessor :install_name
      #
      # # INSTALL_K3S_SYSTEMD_DIR
      # # @return [String]
      # attr_accessor :install_systemd_dir
      #
      # # INSTALL_K3S_TYPE
      # # @return [String]
      # attr_accessor :install_systemd_type
      #
      # # INSTALL_K3S_VERSION
      # # @return [String]
      # attr_accessor :install_version

      def initialize
        @args = UNSET_VALUE
        @config = UNSET_VALUE
        @config_path = UNSET_VALUE
        @env = UNSET_VALUE
        @env_path = UNSET_VALUE
        @installer_url = UNSET_VALUE
      end

      def finalize!
        @args = [] if @args == UNSET_VALUE
        @config = "" if @config == UNSET_VALUE
        @config_path = DEFAULT_CONFIG_PATH if @config_path == UNSET_VALUE
        @env = [] if @env == UNSET_VALUE
        @env_path = DEFAULT_ENV_PATH if @env_path == UNSET_VALUE
        @installer_url = DEFAULT_INSTALLER_URL if @installer_url == UNSET_VALUE

        if @args && args_valid?
          @args = @args.is_a?(Array) ? @args.map { |a| a.to_s } : @args.to_s
        end
      end

      def validate(machine)
        errors = _detected_errors

        unless args_valid?
          errors << "K3s provisioner `args` must be an array or string."
        end

        unless config_valid?
          errors << "K3s provisioner `config` must be a hash or string (yaml)."
        end

        unless env_valid?
          errors << "K3s provisioner `env` must be an array, hash, or string."
        end

        { "k3s provisioner" => errors }
      end

      def args_valid?
        return true unless args
        return true if args.is_a?(String)
        return true if args.is_a?(Integer)
        if args.is_a?(Array)
          args.each do |a|
            return false if !a.kind_of?(String) && !a.kind_of?(Integer)
          end
          return true
        end
        false
      end

      def config_valid?
        return true unless args
        return true if config.is_a?(String)
        return true if config.is_a?(Hash)
        false
      end

      def env_valid?
        return true unless env
        return true if env.is_a?(String)
        return true if env.is_a?(Hash)
        if env.is_a?(Array)
          env.each do |a|
            return false unless a.kind_of?(String)
          end
          return true
        end
        false
      end
    end
  end
end
