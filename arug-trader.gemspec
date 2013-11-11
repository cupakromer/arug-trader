# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arug/trader/version'

Gem::Specification.new do |spec|
  spec.name          = "arug-trader"
  spec.version       = Arug::Trader::VERSION
  spec.authors       = ["Aaron Kromer"]
  spec.description   = %q{Command line tool for calculating item sales across various currencies.}
  spec.summary       = %q{CLI for calculating item sales}
  spec.homepage      = "https://github.com/cupakromer/arug-trader"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "naught"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "emoji-rspec"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
end
