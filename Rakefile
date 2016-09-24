require_relative 'arescentral'
require 'rake'
require 'rake/testtask'

task :run do
  %x[thin --debug --rackup config.ru start -p 9292]
end

desc "Run all specs."
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
    tag = task_args[:tag]
    if (tag)
      t.rspec_opts = "--example #{tag}"
    end
  end
rescue LoadError
  # no rspec available
end

task :default => 'spec:unit'
