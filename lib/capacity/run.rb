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
        "-k -H 'Accept-Encoding: gzip' #{url}"
    end

    def self.ab(options = nil)
      run_options =
        options ? setup_options(options) : Capacity::CapConfig.ab_options

      run_options[:urls] = [run_options[:urls]].flatten

      run_options[:urls].each do |url|
        cmd = ab_command(run_options, url)
        Capacity::Logger.log(:info, cmd)

        run_multiple(run_options, url) do
          Open3.popen3(cmd) do |_stdin, stdout, stderr|
            if stderr.readlines.length > 0
              raise_formatted_error(cmd, stderr.readlines)
            end
            formatted_output = stdout.readlines.reduce { |line, memo| memo += line }
            Capacity::Result.new(formatted_output, run_options)
          end
        end
      end
    end

    def self.run_multiple(options, url, &block)
      average_stats = []
      results_hash = { average: 0,
                       queries_per_second: 0,
                       failed_requests: 0 }
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
        average_stats.each do |current_result|
          results_hash[:average] += current_result.avg_response_time
          results_hash[:queries_per_second] += current_result.queries_per_second
          results_hash[:failed_requests] += current_result.failed_requests
        end
        results_hash.each { |k, v| results_hash[k] = v / options[:runs] }
      else
        Capacity::Logger.log(:info, 'Processing single run')
        results_hash[:average] += result.avg_response_time
        results_hash[:queries_per_second] += result.queries_per_second
        results_hash[:failed_requests] += result.failed_requests
      end
      Capacity::Logger.log(:result, results_hash.merge!(url: url).to_s)
    end

    def self.raise_formatted_error(cmd, err_lines)
      cmd = cmd.red
      err = 'Command failed'.red
      err_s = err_lines.reduce { |line, memo| memo += line }
      err_s = err_s.red if err_s
      raise "#{err}\nCommand: #{cmd}\n#{err_s}"
    end
  end
end
