# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'class_kit/version'
# TODO: remove version file from lib/class_kit/version

lib = File.expand_path('../lib', __FILE__)

version = ''

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

if ENV['GITHUB_REF_NAME'] != nil
  puts "CI Branch - #{ENV['GITHUB_REF_NAME']}"
  version = ENV['GITHUB_REF_NAME']
end

if version.downcase.match /^v/
  version = version.dup
  version.slice!(0)
elsif version.downcase.match /^build/
  # allow none release tags to build alpha, beta, dev versions of the gem.
  version = "0.0.0.#{ENV['GITHUB_REF_NAME']}"
else
  version = '0.0.0'
end


Gem::Specification.new do |spec|
  spec.name          = 'class_kit'
  spec.version       = version
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
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov', '< 0.18.0'

  spec.add_dependency 'hash_kit'
  spec.add_dependency 'json'
end
