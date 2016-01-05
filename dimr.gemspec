# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dimr/version'

Gem::Specification.new do |spec|
  spec.name          = "dimr"
  spec.version       = Dimr::VERSION
  spec.authors       = ["Steve England"]
  spec.email         = ["stephen.england@gmail.com"]

  spec.summary       = %q{DIMr is a small extension to DIM.}
  spec.description   = %q{DIMr is a small extension to Jim Weirich's minimalistic dependency injection framework DIM. It allows easy dependency injection into ruby command classes.}
  spec.homepage      = "https://github.com/stengland/dimr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dim", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
