RAILS_ROOT = "spec/test_application"

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'
require 'tasks/rails'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
      gemspec.name = "trendi18n"
      gemspec.summary = "Database backend for i18n"
      gemspec.description = "Database backend for i18n (localization files are still supported). This is beta version so give me your feedback"
      gemspec.email = "p.misiurek@gmail.com"
      gemspec.authors = ["Piotr Misiurek", "Piotr Marciniak", "Łukasz Piestrzeniewicz"]
      files = FileList["[A-Z]*", "{generators,lib,spec,app,rails}/**/*"]
      files.exclude "spec/test_application/coverage/*"
      files.exclude "spec/test_application/tmp/*"
      files.exclude "spec/test_application/nbproject/*"
      files.exclude "spec/test_application/log/*"
      files.exclude "spec/test_applcation/test/*"
      files.exclude "spec/test_application/db/*sqlite3"
      gemspec.files = files.to_a
      gemspec.homepage = "http://github.com/bragi/trendi18n"
      gemspec.add_dependency("rails", ">= 2.3.5")
  end
   rescue LoadError
      puts "Jeweler not available"
end


desc 'Default: run unit tests.'
task :default => :test

desc 'Test the trendi18n plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the trendi18n plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Trendi18n'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end 



