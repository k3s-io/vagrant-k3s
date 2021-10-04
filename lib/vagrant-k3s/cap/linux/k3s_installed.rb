# frozen_string_literal: true

module VagrantPlugins
  module K3s
    module Cap
      module Linux
        module K3sInstalled
          # Check if K3s is installed at the given version.
          # @return [true, false]
          def self.k3s_installed(machine, k3s="k3s")
            machine.communicate.execute("/usr/bin/which k3s") do |type, data|
              k3s = data.to_s if type == :stdout
            end
            machine.communicate.test("#{k3s} --version", sudo: true)
          end
        end
      end
    end
  end
end
