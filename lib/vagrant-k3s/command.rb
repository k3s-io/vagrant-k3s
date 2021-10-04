# frozen_string_literal: true

require 'vagrant'

module VagrantPlugins
  module K3s
    class Command < Vagrant.plugin('2', :command)
      require_relative 'command/kubectl'

      def self.synopsis
        'Lightweight Kubernetes'
      end

      def execute
        @logger.debug("ITS K3S!")
        0
      end
    end
  end
end
