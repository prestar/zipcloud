# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zipcloud/version'

Gem::Specification.new do |spec|
  spec.name          = "zipcloud"
  spec.version       = Zipcloud::VERSION
  spec.authors       = ["Kaneko Yoshihiro"]
  spec.email         = ["yoshihiro.kaneko@advantest.com"]
  spec.summary       = %q{get PostalAddress from Zipcloud}
  spec.description   = %q{if you want to get PostalAddress, you should input postal code to Zipcloud object.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
