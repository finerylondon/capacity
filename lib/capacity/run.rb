require 'open3'
require 'pp'

module Capacity
  class Run
    def self.setup_options(new_options)
      options = Capacity::CapConfig.ab_options
      new_options.each { |k, v| options[k] = v }
      options
    end

    def self.ab_command(options, url)
      Capacity::Logger.log(:info, "Calling ab on: #{url}")
      "ab -c #{options[:concurrency]} -n #{options[:num_requests]} " \
        "-k -l -H 'Accept-Encoding: gzip' #{url}"
    end

    def self.ab(options = nil)
      run_options =
        options ? setup_options(options) : Capacity::CapConfig.ab_options
      final_results = []

      run_options[:urls] = [run_options[:urls]].flatten

      run_options[:urls].each do |url|
        cmd = ab_command(run_options, url)
        Capacity::Logger.log(:info, cmd)

        run_multiple(run_options, url, final_results) do
          stdout, stderr, exit_status = Open3.capture3(cmd)
          raise_formatted_error(cmd, stderr) if !exit_status.success?
          Capacity::Result.log(stdout)
        end
      end
      final_results
    end

    def self.run_multiple(options, url, final_results, &block)
      average_stats = []

      result = nil
      if options[:runs] == 1
        result = block.call
      else
        options[:runs].times do
          average_stats << block.call
        end
      end
      if !average_stats.empty?
        Capacity::Logger.log(:info, "Processing #{options[:runs]} runs")
        result = Hash.new(0)
        average_stats.each do |current_result|
          current_result.each do |k, v|
            result[k] += current_result[k]
          end
        end
        result.each { |k, v| result[k] = v / options[:runs] }
      else
        Capacity::Logger.log(:info, 'Processing single run')
      end
      result[:url] = url
      final_results << result
      Capacity::Logger.log(:result, result.to_s)
    end

    def self.raise_formatted_error(cmd, err_lines)
      cmd = cmd.red
      err = 'Command failed'.red
      err_lines = err_lines.red
      raise "#{err}\nCommand: #{cmd}\n#{err_s}"
    end
  end
end
