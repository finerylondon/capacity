# require 'capacity/version'
require 'rake'

Dir[File.join(File.dirname(__FILE__), '**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '**/*.rake')].each { |rake| load(rake) }

module Capacity
  def self.root
    File.dirname(File.dirname(__FILE__))
  end
end
