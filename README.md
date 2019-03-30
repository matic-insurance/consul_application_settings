# ConsulApplicationSettings

[![Build Status](https://travis-ci.org/matic-insurance/consul_application_settings.svg?branch=master)](https://travis-ci.org/matic-insurance/consul_application_settings)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b0eaebcf83898535ea4e/test_coverage)](https://codeclimate.com/github/matic-insurance/consul_application_settings/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/b0eaebcf83898535ea4e/maintainability)](https://codeclimate.com/github/matic-insurance/consul_application_settings/maintainability)

Gem that simplifies usage of Consul (via [Diplomat gem](https://github.com/WeAreFarmGeek/diplomat)) 
to host application settings. Gem provides defaults via yaml files and other utilities 
to simplify storage and control of application with Consul KV storage.

Gem is trying to solve a problem of distributing application settings for local development environment and provide defaults 
in production before custom value is set inside of consul. 

Example use cases:

- One engineer has created a new feature that depend on consul key/value. 
  
  How enginner can notify other engineers that they need to set this value in their consul environments?

- DevOps team responsible to configure and maintain deployment. 

  How do they learn (have reference) of what settings and structure application expect? 

Gem reads any particular setting from consul and if it is missing tries to find value in YAML defaults file

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consul_application_settings'
```


## Usage

TODO: Write usage instructions here

## Development

## Development

1. [Install Consul](https://www.consul.io/docs/install/index.html)
1. Run `bin/setup` to install dependencies
1. Run tests `rspec`
1. Add new test
1. Add new code
1. Go to step 3

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matic-insurance/consul_application_settings. 
This project is intended to be a safe, welcoming space for collaboration, 
and contributors are expected to adhere to the 
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ConsulApplicationSettings project’s codebases, issue trackers, 
chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/consul_application_settings/blob/master/CODE_OF_CONDUCT.md).
