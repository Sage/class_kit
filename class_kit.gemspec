lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'class_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'class_kit'
  spec.version       = ClassKit::VERSION
  spec.authors       = ['Sage One']
  spec.email         = ['vaughan.britton@sage.com']

  spec.summary       = 'Toolkit for working with classes'
  spec.description   = 'Toolkit for working with classes'
  spec.homepage      = 'https://github.com/sage/class_kit'
  spec.license       = 'MIT'

  spec.files         = Dir.glob("{bin,lib}/**/**/**")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov', ' ~> 0.22.0'
  spec.add_development_dependency 'simplecov_json_formatter'

  spec.add_dependency 'hash_kit'
  spec.add_dependency 'json'
end
