## [Unreleased]

## [3.0.1]
### Fixes
- Fix exception when preloading settings without consul 

## [3.0.0]
### Breaking Changes
- Use Preloaded Consul Settings Provider by default
### New features
- Configurable setting providers
- Preloaded Consul Settings Provider to prioritize performance over consistency
- Performance tests in spec
- Benchmarking script
### Fixes
- Return nil instead of empty hash when reading missing setting from file
- Return nil instead of empty string when reading missing value from Consul
- Add missing load method on Settings Reader to create object with narrow scope

## [2.1.1]
### Changes
- Update Diplomat to latest version 

## [2.1.0]
### Fixes
- Return nil for unknown keys 

## [2.0.0]
### Breaking Changes
- Change default naming for setting files 

## [1.0.0]
### Features
- Add support for second settings file (local settings for development) 

## [0.1.4]
### Fixes
- Clone values before returning

## [0.1.3]
### Fixes
- Add `Diplomat::PathNotFound` to the list of caught exceptions

## [0.1.2]
### Fixes
- Catch system call errors when consul not available

## [0.1.1]
### New features
- Allow Operations without Consul
### Tech debt
- Replace CI to GitHub Actions

## [0.1.0]
### New features
- Gem init
- Reading settings from consul
- Reading settings from defaults
- Support deep settings search
- Support nested configs

[Unreleased]: https://github.com/matic-insurance/consul_application_settings/compare/3.0.1...HEAD
[3.0.1]: https://github.com/matic-insurance/consul_application_settings/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/matic-insurance/consul_application_settings/compare/2.0.0...3.0.0
[2.1.1]: https://github.com/matic-insurance/consul_application_settings/compare/2.1.0...2.1.1
[2.1.0]: https://github.com/matic-insurance/consul_application_settings/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/matic-insurance/consul_application_settings/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/matic-insurance/consul_application_settings/compare/0.1.4...1.0.0
[0.1.4]: https://github.com/matic-insurance/consul_application_settings/compare/0.1.3...0.1.4
[0.1.3]: https://github.com/matic-insurance/consul_application_settings/compare/0.1.2...0.1.3
[0.1.2]: https://github.com/matic-insurance/consul_application_settings/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/matic-insurance/consul_application_settings/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/matic-insurance/consul_application_settings/compare/cb7194f...0.1.0
