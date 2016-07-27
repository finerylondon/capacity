require 'rake'
require 'yaml'

Dir[File.join(File.dirname(__FILE__), 'capacity/*.rb')]
  .each { |f| require f.split('/').last(2).join('/') }

module Capacity
  def self.root
    File.dirname(File.dirname(__FILE__))
  end
end
