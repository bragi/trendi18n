require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
      gemspec.name = "Trendi18n"
      gemspec.summary = "Database backend for i18n"
      gemspec.description = "Some description"
      gemspec.email = "p.misiurek@gmail.com"
      gemspec.authors = ["Piotr Misiurek"]
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



