# -*- encoding: utf-8 -*-
# stub: dbd-sqlite3 1.2.5 ruby lib

Gem::Specification.new do |s|
  s.name = "dbd-sqlite3".freeze
  s.version = "1.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Erik Hollensbe".freeze, "Christopher Maujean".freeze]
  s.date = "2009-07-11"
  s.description = "SQLite 3.x DBD for DBI".freeze
  s.email = "ruby-dbi-users@rubyforge.org".freeze
  s.extra_rdoc_files = ["README".freeze, "LICENSE".freeze, "ChangeLog".freeze]
  s.files = ["ChangeLog".freeze, "LICENSE".freeze, "README".freeze]
  s.homepage = "http://www.rubyforge.org/projects/ruby-dbi".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.0".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "SQLite 3.x DBD for DBI".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dbi>.freeze, [">= 0.4.0"])
      s.add_runtime_dependency(%q<sqlite3-ruby>.freeze, [">= 0"])
    else
      s.add_dependency(%q<dbi>.freeze, [">= 0.4.0"])
      s.add_dependency(%q<sqlite3-ruby>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<dbi>.freeze, [">= 0.4.0"])
    s.add_dependency(%q<sqlite3-ruby>.freeze, [">= 0"])
  end
end
