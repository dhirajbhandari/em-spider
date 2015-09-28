$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'spider'
require 'rspec/core/rake_task'

Dir[spider.root + 'tasks/*.rake'].each {|file| load file}

desc "Run specifications"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
