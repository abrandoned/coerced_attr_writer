# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coerced_attr_writer/version'

Gem::Specification.new do |gem|
  gem.name          = "coerced_attr_writer"
  gem.version       = CoercedAttrWriter::VERSION
  gem.authors       = ["Brandon Dewitt"]
  gem.email         = ["brandonsdewitt+coerced_attr_writer@gmail.com"]
  gem.description   = %q{ setters with type coercion for set* methods on java classes using the jruby coercion interface `to_java(java_type)` }
  gem.summary       = %q{ declarable coercible attr_writer methods for interacting with native java methods }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.platform      = "java"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry-nav"
end
