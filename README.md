# ConsulApplicationSettings

![Build Status](https://github.com/matic-insurance/consul_application_settings/workflows/ci/badge.svg?branch=master)
[![Test Coverage](https://codecov.io/gh/matic-insurance/consul_application_settings/branch/master/graph/badge.svg?token=5E8NA8EE8L)](https://codecov.io/gh/matic-insurance/consul_application_settings)

This gem that simplifies usage of Consul (via [Diplomat gem](https://github.com/WeAreFarmGeek/diplomat)) 
to host application settings. 

Except reading value from Consul the gem also:
- Fallbacks to YAML if value is missing in consul
- Resolve actual value from other sources to facilitate overriding via ENV, storing secret values in Vault,  
  or executing small ERB snippets 

Default values in YAML also can be considered as a way to communicate structure of settings to other engineers.
Default values also support local settings to allow override on local environment or deployment in production.

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
  # Specify path to the base settings YML. Default: 'config/app_settings.yml' 
  config.base_file_path = Rails.root.join('config/app_settings.yml')
  # Specify path to the local settings YML, which overrides the base file. Default: 'config/app_settings.local.yml'
  config.local_file_path = Rails.root.join('config/app_settings.local.yml')
  # Specify whether exception should be thrown on Consul connection errors. Default: false
  config.disable_consul_connection_errors = true
  # Specify setting providers. Default: [ConsulApplicationSettings::Providers::ConsulPreloaded, ConsulApplicationSettings::Providers::LocalStorage]
  config.settings_providers = [
    ConsulApplicationSettings::Providers::Consul,          
    ConsulApplicationSettings::Providers::LocalStorage          
  ]
  # Specify how values will be additionally resolved. Default: [ConsulApplicationSettings::Resolvers::Env] 
  config.value_resolvers = [
    ConsulApplicationSettings::Resolvers::Erb,
    ConsulApplicationSettings::Resolvers::Env,
  ]
end

# Specify path to settings both in YML files and Consul
AUTH_SETTIGNS = ConsulApplicationSettings.load('my_cool_app')
# Load at root without any prefix: APP_SETTINGS = ConsulApplicationSettings.load
```

**NOTE** For rails you can add this code to custom initializer `console_application_settings.rb` in `app/config/initializers`

**NOTE** Diplomat gem should be configured before requesting any settings

### Settings structure

Assuming your defaults file in repository `config/application_settings.yml` looks like:
```yaml
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
db_settings = APP_SETTINGS.load('integrations/database') # ConsulApplicationSettings::Reader
db_settings.get(:domain)                  # "194.78.92.19"
db_settings['user']                       # "app"

#if you try to get subsettings via get - error is raised
APP_SETTINGS.get('integrations/database') # raise ConsulApplicationSettings::Error
```

## Advanced Configurations

### Setting Providers
Providers controls how and in which order settings are retrieved. 
When application asks for specific setting - gem retrieves them from every provider in order of configuration
until one returns not nil value.

Default order for providers is:
1. `ConsulApplicationSettings::Providers::ConsulPreloaded`
2. `ConsulApplicationSettings::Providers::LocalStorage`

List of built in providers:
- `ConsulApplicationSettings::Providers::ConsulPreloaded` - Retrieves all settings from consul on every `.load`
- `ConsulApplicationSettings::Providers::Consul` - Retrieves setting every time `.get` method is called
- `ConsulApplicationSettings::Providers::LocalStorage` - Retrieves all settings from local files on every `.load`

Custom provider can be added as long as it support following interface:
```ruby
class CustomProvider
  #constructor
  def initialize(base_path, config)
  end
  
  # get value by `base_path + '/' + path`
  def get(path)
  end
end
```

### Resolvers
Once value is retrieved - it will be additionally processed by resolvers. 
This allows for additional flexibility like getting values from external sources. 
While every resolver can be implemented in a form of a provider - one will be limited by the structure of settings, 
while other system might not be compatible with this.

When value is retrieved - gem finds **first** provider that can resolve value and resolves it. 
Resolved value is returned to application.

Default list of resolvers:
- `ConsulApplicationSettings::Resolvers::Env`

List of built in resolvers
- `ConsulApplicationSettings::Resolvers::Env` - resolves any value by looking up environment variable. 
  Matching any value that starts with `env://`. Value like `env://TEST_URL` will be resolved as `ENV['TEST_URL']`
- `ConsulApplicationSettings::Resolvers::Erb` - resolves value by rendering it via ERB. 
  Matching any value that contains `<%` and `%>` in it. Value like `<%= 2 + 2 %>` will be resolved as `4`

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
| settings_providers               | no       | Array(Provider)                         | Array   | Specify custom setting provider lists                                        |
| value_resolvers                  | no       | Array(Resolver)                         | Array   | Specify custom value resolvers lists                                         |

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
