# -*- encoding: utf-8 -*-
# stub: dbi 0.4.5 ruby lib

Gem::Specification.new do |s|
  s.name = "dbi".freeze
  s.version = "0.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Erik Hollensbe".freeze, "Christopher Maujean".freeze]
  s.date = "2010-05-17"
  s.description = "A vendor independent interface for accessing databases, similar to Perl's DBI".freeze
  s.email = "ruby-dbi-users@rubyforge.org".freeze
  s.executables = ["dbi".freeze, "test_broken_dbi".freeze]
  s.extra_rdoc_files = ["README".freeze, "LICENSE".freeze, "ChangeLog".freeze]
  s.files = ["ChangeLog".freeze, "LICENSE".freeze, "README".freeze, "bin/dbi".freeze, "bin/test_broken_dbi".freeze]
  s.homepage = "http://www.rubyforge.org/projects/ruby-dbi".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.0".freeze)
  s.rubyforge_project = "ruby-dbi".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "A vendor independent interface for accessing databases, similar to Perl's DBI".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<deprecated>.freeze, ["= 2.0.1"])
    else
      s.add_dependency(%q<deprecated>.freeze, ["= 2.0.1"])
    end
  else
    s.add_dependency(%q<deprecated>.freeze, ["= 2.0.1"])
  end
end
