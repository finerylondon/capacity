module Capacity
  module CapConfig
    class << self
      attr_accessor :ab_options, :config
    end

    def self.load
      config_path = File.join('./config/config.yml')
      YAML.load_file(config_path)
    end

    def self.symbolize_keys(hash)
      {}.tap do |result|
        hash.each_key { |key| result[key.to_sym] = hash[key] }
      end
    end

    @config = self.symbolize_keys(CapConfig.load)

    @ab_options = {
      urls: @config[:urls],
      runs: @config[:runs],
      concurrency: @config[:concurrency],
      num_requests: @config[:num_requests]
    }

    puts @ab_options

  end
end
