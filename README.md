# ConsulApplicationSettings

![Build Status](https://github.com/matic-insurance/consul_application_settings/workflows/ci/badge.svg?branch=master)
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

**NOTE** Consul is requested every time you query the settings. Defaults YAML file is loaded in memory and is not changing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consul_application_settings'
```

## Usage

### Initialization

At the load of application: 
```ruby
ConsulApplicationSettings.configure do |config|
  # Specify path to the base settings YML. Default: 'config/application_settings.yml' 
  config.base_file_path = Rails.root.join('config/my_settings.yml')
  # Specify path to the local settings YML, which overrides the base file. Default: 'config/application_settings.local.yml'
  config.local_file_path = Rails.root.join('config/my_settings.local.yml')
  # Specify whether exceprion should be thrown on Consul connection errors. Default: false
  config.disable_consul_connection_errors = true
end

APP_SETTINGS = ConsulApplicationSettings.load
# Specify path to settings both in YML files and Consul
AUTH_SETTIGNS = ConsulApplicationSettings.load('authentication')
```

**NOTE** For rails you can add this code to custom initializer `console_application_settings.rb` in `app/config/initializers`

**NOTE** Diplomat gem should be configured before requesting any settings

### Settings structure

Assuming your defaults file in repository `config/application_settings.yml` looks like:
```yaml
staging:
  my_cool_app:
    app_name: 'MyCoolApp'
    hostname: 'http://localhost:3001'
    
    integrations:
      database:
        domain: localhost
        user: app
        password: password1234
      slack:
        enabled: false
        webhook_url: 'https://hooks.slack.com/services/XXXXXX/XXXXX/XXXXXXX'
```

And consul has following settings
```json
{
  "staging": {
    "my_cool_app": {
     "hostname": "https://mycoolapp.com",
     "integrations": {
        "database": {
          "domain": "194.78.92.19",
          "password": "*************"
        },
        "slack": {
          "enabled": "true"
        }
      }
    }
  }
}
```

### Query settings via full path

Anywhere in your code base, after initialization, you can use 
previously loaded settings to query any key by full path

```ruby
APP_SETTINGS['app_name']                           # "MyCoolApp"
APP_SETTINGS.get(:hostname)                     # "https://mycoolapp.com"

APP_SETTINGS.get('integrations/database/user')  # "app"
APP_SETTINGS['integrations/slack/enabled']      # true
```

### Nested settings

Assuming some part of your code needs to work with smaller part of settings - 
gem provides interface to avoid duplicating absolute path

```ruby
# You can load subsettings from root object
db_settings = APP_SETTINGS.load('integrations/database')
db_settings.get(:domain)                  # "194.78.92.19"
db_settings['user']                       # "app"
``` 

### Gem Configuration
You can configure gem with block:
```ruby
ConsulApplicationSettings.configure do |config|
  config.local_file_path = 'config/config.yml'
end
```
or one option at a time
```ruby
ConsulApplicationSettings.config.local_file_path = 'config/config.yml'
```

All Gem configurations

| Configuration                    | Required | Default | Type    | Description                                                                                                  |
|----------------------------------|----------|-----------------------------------------|---------|------------------------------------------------------------------------------|
| base_file_path                   | no       | 'config/application_settings.yml'       | String  | Path to the file with base settings                                          |
| local_file_path                  | no       | 'config/application_settings.local.yml' | String  | Path to the file with local settings overriding the base settings            |
| disable_consul_connection_errors | no       | true                                    | Boolean | Do not raise exception when consul is not available (useful for development) |

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
