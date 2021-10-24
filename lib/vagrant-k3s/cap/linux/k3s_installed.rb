# frozen_string_literal: true

module VagrantPlugins
  module K3s
    module Cap
      module Linux
        module K3sInstalled
          # Check if K3s is installed.
          # @return [true, false]
          def self.k3s_installed(machine)
            machine.communicate.test("which k3s", sudo: true)
          end
        end
      end
    end
  end
end
