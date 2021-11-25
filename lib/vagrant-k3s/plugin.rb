# frozen_string_literal: true

require_relative 'version'

module VagrantPlugins
  module K3s
    class Plugin < Vagrant.plugin(2)
      name 'k3s'
      description 'Lightweight Kubernetes'

      config(:k3s, :provisioner) do
        require_relative 'config'
        Config
      end

      provisioner(:k3s) do
        require_relative 'provisioner'
        Provisioner
      end

      command(:k3s, primary: true) do
        require_relative 'command'
        Command
      end

      guest_capability(:linux, :k3s_installed) do
        require_relative "cap/linux/k3s_installed"
        Cap::Linux::K3sInstalled
      end

      guest_capability(:linux, :k3s_kubectl) do
        require_relative "cap/linux/k3s_kubectl"
        Cap::Linux::K3sKubectl
      end

      guest_capability(:linux, :curl_installed) do
        require_relative "cap/linux/curl_installed"
        Cap::Linux::CurlInstalled
      end

      guest_capability(:alpine, :curl_install) do
        require_relative "cap/alpine/curl_install"
        Cap::Alpine::CurlInstall
      end

      guest_capability(:debian, :curl_install) do
        require_relative "cap/debian/curl_install"
        Cap::Debian::CurlInstall
      end

      guest_capability(:redhat, :curl_install) do
        require_relative "cap/redhat/curl_install"
        Cap::Redhat::CurlInstall
      end

      guest_capability(:suse, :curl_install) do
        require_relative "cap/suse/curl_install"
        Cap::Suse::CurlInstall
      end
    end
  end
end
