# frozen_string_literal: true

module VagrantPlugins
  module K3s
    module Cap
      module Debian
        module CurlInstall
          def self.curl_install(machine)
            machine.communicate.sudo("apt-get update -y -qq")
            machine.communicate.sudo("apt-get install -y -qq curl")
          end
        end
      end
    end
  end
end
