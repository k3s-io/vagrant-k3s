# frozen_string_literal: true

begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant K3s plugin must be run within Vagrant.'
end

require_relative 'vagrant-k3s/plugin'
require_relative 'vagrant-k3s/version'
