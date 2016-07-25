require 'yaml'

module Capacity
  module CapConfig
    class << self
      attr_accessor :ab_options, :config
    end

    def self.load
      config_path = File.join(File.dirname(File.dirname(__FILE__)), '/config/config.yml')
      config_file = YAML.load_file(config_path)
      @config = symbolize_keys(config_file)

      @ab_options = {
        urls: @config[:urls],
        runs: @config[:runs],
        concurrency: @config[:concurrency],
        num_requests: @config[:num_requests]
      }
    end

    def self.symbolize_keys(hash)
      {}.tap do |result|
        hash.each_key { |key| result[key.to_sym] = hash[key] }
      end
    end

    CapConfig.load
  end
end
