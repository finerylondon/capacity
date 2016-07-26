require 'yaml'

module Capacity
  module CapConfig
    class << self
      attr_accessor :ab_options, :config
    end

    def self.load
      config_file = load_or_generate_config

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

    def self.load_or_generate_config
      config_path = File.join(File.dirname(File.dirname(__FILE__)), '/config/config.yml')
      begin
        YAML.load_file(config_path)
      rescue Errno::ENOENT
        create_default_config_file
        YAML.load_file(config_path)
      end
    end

    def self.create_default_config_file
      File.open(File.join(File.join(File.dirname(File.dirname(__FILE__)), '/config/config.yml')), 'w+') do |f|
        f.puts "urls: 'http://staging.finerylondon.com/'"
        f.puts 'runs: 1'
        f.puts 'concurrency: 10'
        f.puts 'num_requests: 100'
      end
    end

    def self.update_config(opts)
      file_path = File.join(File.dirname(File.dirname(__FILE__)), '/config/config.yml')
      original_file = IO.readlines(file_path)

      new_file = build_file(original_file, opts)

      write_config(file_path, new_file) if new_file.size
      Capacity::CapConfig.load
    end

    def self.build_file(original_file, opts)
      ''.tap do |str|
        original_file.each do |line|
          updated_line =
            opts.reduce('') do |line_str, (k, v)|
              key_name = long_key(k)
              if v && line.include?(key_name)
                line_str << "#{key_name}: #{v}\n"
              else
                line_str
              end
            end
          str << (updated_line.length > 0 ? updated_line : line)
        end
      end
    end

    def self.write_config(path, new_file)
      file = File.open(path, 'w+')
      file.write(new_file)
      file.close
    end

    def self.long_key(key)
      case key
      when :urls
        'urls'
      when :runs
        'runs'
      when :conc
        'concurrency'
      when :reqs
        'num_requests'
      end
    end

    load
  end
end
