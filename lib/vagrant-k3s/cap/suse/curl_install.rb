require_relative '../linux/curl_installed'

module VagrantPlugins
  module K3s
    module Cap
      module Suse
        module CurlInstall extend Linux::CurlInstalled
          def self.curl_install(machine)
            unless curl_installed?(machine)
              machine.communicate.sudo("zypper -n -q update")
              machine.communicate.sudo("zypper -n -q install curl")
            end
          end
        end
      end
    end
  end
end
