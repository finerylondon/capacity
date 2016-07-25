require 'bundler/gem_tasks'

Dir[File.join(File.dirname(__FILE__), '**/*.rb')]
  .each { |f| require f }

Dir[File.join(File.dirname(__FILE__), 'lib/**/*.rake')]
  .each { |rake| load(rake) }
