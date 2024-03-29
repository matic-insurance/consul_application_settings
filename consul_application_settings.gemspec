lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'consul_application_settings/version'

Gem::Specification.new do |spec|
  spec.name = 'consul_application_settings'
  spec.version = ConsulApplicationSettings::VERSION
  spec.authors = ['Volodymyr Mykhailyk']
  spec.email = ['volodymyr.mykhailyk@gmail.com']

  spec.summary = 'Application settings via Consul with yaml defaults'
  spec.description = 'Gem that simplifies usage of Consul (via Diplomat gem) to host application settings.
                      Gem provides defaults and utilities'
  spec.homepage = 'https://github.com/matic-insurance/consul_application_settings'
  spec.license = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/matic-insurance/consul_application_settings'
    spec.metadata['changelog_uri'] = 'https://github.com/matic-insurance/consul_application_settings/blob/master/CHANGELOG.md'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'deep_merge', '~> 1.2'
  spec.add_dependency 'diplomat', '~> 2.5.1'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'codecov', '~> 0.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.66'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.32.0'
  spec.add_development_dependency 'simplecov', '~> 0.16'

  spec.post_install_message = <<~MESSAGE
    !    The 'consul_application_settings' gem has been deprecated and has been replaced by 'settings_reader'.
    !    See: https://rubygems.org/gems/settings_reader
    !    And: https://github.com/matic-insurance/settings_reader
  MESSAGE
end
