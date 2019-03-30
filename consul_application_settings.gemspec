
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "consul_application_settings/version"

Gem::Specification.new do |spec|
  spec.name          = "consul_application_settings"
  spec.version       = ConsulApplicationSettings::VERSION
  spec.authors       = ["Volodymyr Mykhailyk"]
  spec.email         = ["volodymyr.mykhailyk@gmail.com"]

  spec.summary       = %q{Application settings via Consul with yaml defaults}
  spec.description   = %q{Gem that simplifies usage of Consul (via Diplomat gem) to host application settings.
                          Gem provides defaults and utilities}
  spec.homepage      = "https://github.com/matic-insurance/consul_application_settings"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/matic-insurance/consul_application_settings"
    spec.metadata["changelog_uri"] = "https://github.com/matic-insurance/consul_application_settings/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
