require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the migration_foo plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the migration_foo plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MigrationFoo'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :test do
    desc 'Measure test coverage'
    task :coverage do
      system("rcov --rails --text-summary -Ilib --xrefs --html test/unit/*_test.rb") 
      #test/functional/*_test.rb test/views/*_test.rb test/integration/*_test.rb")
      system("open coverage/index.html") if PLATFORM['darwin']
      system("firefox coverage/index.html") if PLATFORM['linux']
     end
end

