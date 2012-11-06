# -*- encoding: utf-8 -*-
require File.expand_path('../lib/brainz/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vilius Luneckas"]
  gem.email         = ["vilius.luneckas@gmail.com"]
  gem.description   = %q{Artificial Neural Network library written in Ruby}
  gem.summary       = %q{Artificial Neural Network library written in Ruby}
  gem.homepage      = "https://github.com/ViliusLuneckas/brainz/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "brainz"
  gem.require_paths = ["lib"]
  gem.version       = Brainz::VERSION
  %w(rspec mocha).each do |gem_name|
    gem.add_development_dependency gem_name
  end
end
