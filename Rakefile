require "bundler/gem_tasks"

Dir[File.join(File.dirname(__FILE__), "lib/**/*.rb")].each { |f| require f }

Dir[File.join(File.dirname(__FILE__), "lib/**/*.rake")].each  { |rake| load(rake) }

task :run
task configure: [:urls, :runs, :conc, :reqs]
