# frozen_string_literal: true

module VagrantPlugins
  module K3s
    class CommandKubectl < Vagrant.plugin(2, :command)
      def execute
        # puts "kubectl"
        0
      end
    end
  end
end
