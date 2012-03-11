# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "brainz"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Vilius Luneckas"]
  s.date = "2012-03-11"
  s.description = "Simple artificial intelligence"
  s.email = "vilius.luneckas@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "lib/brainz.rb", "lib/brainz/backpropagation.rb", "lib/brainz/brainz.rb", "lib/brainz/loader.rb", "lib/brainz/math_utils.rb", "lib/brainz/version.rb", "lib/ext/array.rb"]
  s.files = ["README.rdoc", "Rakefile", "brainz.gemspec", "examples/and.rb", "examples/sign.rb", "examples/xor.rb", "lib/brainz.rb", "lib/brainz/backpropagation.rb", "lib/brainz/brainz.rb", "lib/brainz/loader.rb", "lib/brainz/math_utils.rb", "lib/brainz/version.rb", "lib/ext/array.rb", "spec/array_spec.rb", "spec/brainz_spec.rb", "spec/loader_spec.rb", "spec/spec_helper.rb", "spec/temp/brainz.b", "Manifest"]
  s.homepage = "https://github.com/ViliusLuneckas/brainz/"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Brainz", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "brainz"
  s.rubygems_version = "1.8.17"
  s.summary = "Simple artificial intelligence"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
