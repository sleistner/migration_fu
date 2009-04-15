Gem::Specification.new do |s|
  s.name = %q{migration_fu}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steffen Leistner"]
  s.date = %q{2008-11-12}
  s.description = %q{Rails gem / plugin which generates mysql foreign key constraints.}
  s.email = %q{sleistner@gmail.com}
  s.extra_rdoc_files = ["lib/migration_fu.rb", "README.rdoc"]
  s.files = ["init.rb", "install.rb", "lib/migration_fu.rb", "Rakefile", "README.rdoc", "test/migration_fu_test.rb", "Manifest", "migration_fu.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/sleistner/migration_fu}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Migration_fu", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{migration_fu}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Add or remove foreign keys from migrations.}
  s.test_files = ["test/migration_fu_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
