# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shark/version"

Gem::Specification.new do |spec|
  spec.name          = "bima-shark-sdk"
  spec.version       = Shark::VERSION
  spec.authors       = ["Huy Dinh", "Johannes Schmeißer", "Joergen Dahlke"]
  spec.email         = ["huy.dinh@infopark.de", "johannes.schmeisser@infopark.de", "joergen.dahlke@infopark.de"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4.1.0"
  spec.add_dependency "rack"
  spec.add_dependency "faraday"
  spec.add_dependency "net-http-persistent"
  spec.add_dependency "json_api_client", "~> 1.5"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
end
