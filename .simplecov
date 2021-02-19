if ENV["COVERAGE"]
  SimpleCov.start
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end