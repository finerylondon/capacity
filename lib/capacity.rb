# require 'capacity/version'
require 'rake'
require 'yaml'

Dir[File.join(File.dirname(__FILE__), '**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '**/*.rake')].each { |rake| load(rake) }

module Capacity
end
