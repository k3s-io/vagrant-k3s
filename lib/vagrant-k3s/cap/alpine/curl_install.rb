# frozen_string_literal: true

module VagrantPlugins
  module K3s
    module Cap
      module Alpine
        module CurlInstall
          def self.curl_install(machine)
            machine.communicate.sudo("apk --quiet add --no-cache --no-progress curl")
          end
        end
      end
    end
  end
end
