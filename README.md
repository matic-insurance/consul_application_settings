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

**NOTE** Consul is requested every time you query the settings. Defaults YAML file loaded in memory and not changing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consul_application_settings'
```

## Usage

### Initialization

At the load of application 
```ruby
ConsulApplicationSettings.configure do |config|
  # Specify path to defaults file
  config.defaults = Rails.root.join('config/settings.yml')
  # Specify namespace to consul settings
  config.namespace = 'staging/my_cool_app'
end

APP_SETTINGS = ConsulApplicationSettings.load
```

**NOTE** For rails you can add this code to custom initializer `console_application_settings.rb` in `app/config/initializers`

**NOTE** Diplomat gem should be configured before requesting any settings

### Settings structure

Assuming your defaults file in repository `config/settings.yml` looks like:
```yaml
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
  "production": {
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
APP_SETTINGS.app_name                           # "MyCoolApp"
APP_SETTINGS.get(:hostname)                     # "https://mycoolapp.com"

APP_SETTINGS.get('integrations/database/user')  # "app"
APP_SETTINGS['integrations/slack/enabled']      # true
```

**NOTE** Gem is pulling settings from consul with namespace but ignores namespace for defaults

### Nested settings

Assuming some part of your code needs to work with smaller part of settings - 
gem provides interface to avoid duplicating absolute path

```ruby
# You can load subsettings from root object
db_settings = APP_SETTINGS.load_from('integrations/database')
db_settings.domain                  # "194.78.92.19"
db_settings['user']                 # "app"

# You can load subsettings from subsettings
integrations_settings = APP_SETTINGS.load_from('integrations')
slack_settings = integrations_settings.load_from('slack')  
slack_settings.enabled              # true
slack_settings.get('webhook_url')   # "https://hooks.slack.com/services/XXXXXX/XXXXX/XXXXXXX"
``` 

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
