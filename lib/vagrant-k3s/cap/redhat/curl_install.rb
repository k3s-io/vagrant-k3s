# frozen_string_literal: true

module VagrantPlugins
  module K3s
    module Cap
      module Redhat
        module CurlInstall
          include Linux::CurlInstalled
          def self.curl_install(machine)
            machine.communicate.sudo <<~EOF
              if command -v dnf; then
                dnf -y install curl
              else
                yum -y install curl
              fi
            EOF
          end
        end
      end
    end
  end
end
