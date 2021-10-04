# Vagrant::K3s

## Installation

```shell
vagrant plugin install vagrant-k3s
vagrant up --provider=<your favorite provider>
```

## Usage

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "centos/stream8"
  config.vm.provision :k3s do |k3s|
    # installer_url: can be anything that curl can access from the guest
    # default =>`https://get.k3s.io`
    # type => String
    k3s.installer_url = 'https://get.k3s.io'

    # args: are command line arguments to be passed to the shell, e.g.:
    # `curl ... | sh -s - #{args}`
    # type => String || Array<string>
    k3s.args = "server --token=vagrant"
    # or
    k3s.args = %w[server --token=vagrant]

    # env: environment variables to be set before invoking the installer script
    # type => String || Array<String> || Hash
    k3s.env = %w[K3S_KUBECONFIG_MODE=0640 K3S_SELINUX=true]
    # or
    k3s.env = ENV.select{|k| k.start_with?('K3S_') || k.start_with?('INSTALL_K3S_')}.merge({
      :K3S_KUBECONFIG_MODE => '0640', # pass this as a string unless you like weird results in your guest ...
      :K3S_SELINUX => true,
    })
    # or
    k3s.env = <<~ENV
      K3S_KUBECONFIG_MODE=0640
      K3S_SELINUX=true
    ENV

    # env_path: where to write the envvars to be source prior to invoking the installer script
    # default => `/etc/rancher/k3s/install.env`
    k3s.env_path = '/etc/rancher/k3s/install.env'

    # config: config file content in yaml
    # type => String || Hash
    k3s.config = {
      :disable => %w[local-storage servicelb]
    }
    # or
    k3s.config = <<~YAML
      disable:
      - local-storage
      - servicelb
    YAML

    # config_path: where to write the config yaml.
    # if you override this be sure to let k3s know, e.g.
    #   k3s.env = { :INSTALL_K3S_EXEC => '--config=/some/other/config.yaml' }
    # or
    #   k3s.args = '--config=/some/other/config.yaml'
    # default => `/etc/rancher/k3s/conf.yaml`
    k3s.config_path = '/etc/rancher/k3s/conf.yaml'
  end
end

```
## Development

See https://www.vagrantup.com/docs/plugins/development-basics

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dweomer/vagrant-k3s. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dweomer/vagrant-k3s/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Vagrant::K3s project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dweomer/vagrant-k3s/blob/master/CODE_OF_CONDUCT.md).
