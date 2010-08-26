require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the core plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the core plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Core'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "qcore"
    gemspec.summary = "Qwerty Core"
    gemspec.description = "Qwerty Core"
    gemspec.email = "kris.leech@interkonect.com"
    gemspec.homepage = "http://interkonect.com"
    gemspec.authors = ["Kris Leech"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

