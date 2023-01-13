# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shark/version'

Gem::Specification.new do |spec|
  spec.name          = 'bima-shark-sdk'
  spec.version       = Shark::VERSION
  spec.authors       = ['bima-team@justrelate.com']
  spec.email         = ['bima-team@justrelate.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'https://github.com/infopark-customers/bima-shark-sdk'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|pkg)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.1.0'
  spec.add_dependency 'faraday'
  spec.add_dependency 'json_api_client', '>= 1.10.0'
  spec.add_dependency 'net-http-persistent'
  spec.add_dependency 'rack'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.81.0'
  spec.add_development_dependency 'webmock', '~> 2.3'
end
