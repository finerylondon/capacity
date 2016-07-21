module Capacity
  class Result
    attr_accessor :raw, :options

    def initialize(raw_output, options)
      @raw = raw_output
      @options = options
    end

    def command
      Capacity::Run.ab_command(@options)
    end

    def avg_response_time
      raw.match(/Time per request:\s*([\d\.]+)\s\[ms\]\s\(mean\)/)[1].to_f
    end

    def queries_per_second
      raw.match(/Requests per second:\s*([\d\.]+)\s\[#\/sec\]\s\(mean\)/)[1].to_f
    end

    def failed_requests
      raw.match(/Failed requests:\s*([\d\.]+)/)[1].to_i
    end

    def log
      Capacity::Logger.log(:ab_result, command.to_s)
      Capacity::Logger.log(:ab_result,
                           "Average Response Time: #{avg_response_time}")
      Capacity::Logger.log(:ab_result,
                           "Queries per Second: #{queries_per_second}")
      Capacity::Logger.log(:ab_result, "Failed requests: #{failed_requests}")
    end
  end
end
