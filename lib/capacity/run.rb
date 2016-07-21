require 'open3'
require 'pp'

module Capacity
  class Run
    def self.validate_options(options)
      raise "Options missing: ':url'" unless options.key? :url
      Capacity::Config.ab_options.merge(options)
    end

    def self.ab_command(options)
      options = validate_options(options)
      url = Capacity::Page.get_url(options, true)
      Capacity::Logger.log(:info, "Calling ab on:  #{url}")
      "ab -c #{options[:concurrency]} -n #{options[:num_requests]} " \
        "-k -H 'Accept-Encoding: gzip' #{url}"
    end

    def self.ab(options)
      cmd = ab_command(options)
      result = nil

      puts cmd

      Open3.popen3(cmd) do |_stdin, stdout, stderr|
        if stderr.readlines.length > 0
          raise_formatted_error(cmd, stderr.readlines)
        end
        formatted_output = stdout.readlines.reduce { |line, memo| memo += line }
        result = Capacity::Result.new(formatted_output, options)
      end
      result.log
      { average: result.avg_response_time,
        queries_per_second: result.queries_per_second,
        failed_requests: result.failed_requests }
    end

    def self.raise_formatted_error(cmd, err_lines)
      cmd = cmd.cyan
      err = 'Command failed'.red
      err_s = err_lines.reduce { |line, memo| memo += line }
      err_s = err_s.red if err_s
      raise "#{err}\nCommand: #{cmd}\n#{err_s}"
    end
  end
end
