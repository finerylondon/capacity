require 'yaml'

module Capacity
  module CapConfig
    class << self
      attr_accessor :ab_options, :config
    end

    def self.load
      config_path = File.join(File.dirname(File.dirname(__FILE__)), '/config/config.yml')
      begin
        config_file = YAML.load_file(config_path)
      rescue
        create_config_file
      end
      @config = symbolize_keys(config_file || YAML.load_file(config_path))

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

    def self.create_config_file
      File.open(File.join(File.join(File.dirname(File.dirname(__FILE__)), '/config/config.yml')), 'w+') do |f|
        f.puts "urls: 'http://staging.finerylondon.com/'"
        f.puts 'runs: 1'
        f.puts 'concurrency: 10'
        f.puts 'num_requests: 100'
      end
      CapConfig.load
    end

    CapConfig.load
  end
end
