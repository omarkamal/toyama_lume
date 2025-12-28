# -*- encoding: utf-8 -*-
# stub: geokit 1.14.0 ruby lib

Gem::Specification.new do |s|
  s.name = "geokit".freeze
  s.version = "1.14.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Noack".freeze, "James Cox".freeze, "Andre Lewis".freeze, "Bill Eisenhauer".freeze]
  s.date = "2023-01-24"
  s.description = "Geokit provides geocoding and distance calculation in an easy-to-use API".freeze
  s.email = ["michael+geokit@noack.com.au".freeze]
  s.extra_rdoc_files = ["README.markdown".freeze]
  s.files = ["README.markdown".freeze]
  s.homepage = "http://github.com/geokit/geokit".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.markdown".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.9".freeze)
  s.rubygems_version = "3.4.4".freeze
  s.summary = "Geokit: encoding and distance calculation gem".freeze

  s.installed_by_version = "3.6.9".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, [">= 1.0".freeze])
  s.add_development_dependency(%q<coveralls_reborn>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<mocha>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<pre-commit>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov-rcov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<typhoeus>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<vcr>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<webmock>.freeze, [">= 0".freeze])
end
