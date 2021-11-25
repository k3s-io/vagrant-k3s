# frozen_string_literal: true

module VagrantPlugins
  module K3s
    module Cap
      module Linux
        module K3sKubectl
          def self.k3s_kubectl(machine,*args)
            cmd = "k3s kubectl #{args.join(' ')}"
            machine.ui.info cmd
            begin
              machine.communicate.execute(cmd) do |type, data|
                machine.ui.detail data.chomp, :color => type == :stderr ? :red : :green
              end
            rescue Vagrant::Errors::VagrantError
              return 0
            end
          end
        end
      end
    end
  end
end
