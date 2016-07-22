require 'rake'
require 'yaml'

# require 'capacity/cap_config'
# require 'capacity/log_writer'
# require 'capacity/logger'
# require 'capacity/result'
# require 'capacity/run'
# require 'capacity'
# require 'capacity/version'

Dir[File.join(File.dirname(__FILE__), 'capacity/*.rb')]
  .each { |f| require f.split('/').last(2).join('/') }

module Capacity
  def self.root
    File.dirname(File.dirname(__FILE__))
  end
end
