# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "mrdialog"
  gem.homepage = "http://github.com/muquit/mrdialog"
  gem.license = "MIT"
  gem.summary = %Q{A ruby gem for ncurses dialog program, based on the gem rdialog}
  gem.description = %Q{A ruby gem for ncurses dialog program.
      This gem is based on rdialog (http://rdialog.rubyforge.org/) by
      Aleks Clark. I added support for missing widgets, fixed 
      bugs and wrote the sample apps. I am 
      also renaming the class to MRDialog to avoid conflicts.
      Please look at ChangeLog.md for details.  }
  gem.email = "muquit@gmail.com"
  gem.authors = ["Aleks Clark", "Muhammad Muquit"]
  gem.files.include 'lib/mrdialog.rb'
  gem.files.include 'lib/mrdialog/mrdialog.rb'
  gem.files.include 'samples/*'
  gem.files.include 'VERSION'
  gem.files.include 'README.md'
  gem.files.include 'ChangeLog.md'
  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mrdialog #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
