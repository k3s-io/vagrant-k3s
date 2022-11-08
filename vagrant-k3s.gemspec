# frozen_string_literal: true
$:.unshift File.expand_path("../lib", __FILE__)
require 'vagrant-k3s/version'

Gem::Specification.new do |spec|
  spec.name         = 'vagrant-k3s'
  spec.version      = VagrantPlugins::K3s::VERSION
  spec.platform     = Gem::Platform::RUBY
  spec.authors      = ['Derek Nola', 'Jacob Blain Christen']
  spec.email        = ['derek.nola@suse.com', 'dweomer5@gmail.com']

  spec.license      = 'Apache-2.0'

  spec.summary      = 'Manage k3s installations on Vagrant guests.'
  spec.description  = spec.summary
  spec.homepage     = 'https://github.com/k3s-io/vagrant-k3s'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.required_ruby_version     = ">= 2.5", "< 3.1"
  spec.required_rubygems_version = ">= 1.3.6"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
