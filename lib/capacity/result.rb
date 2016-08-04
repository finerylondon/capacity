module Capacity
  class Result

    def self.avg_response_time
      safe_integer(/Time per request:\s*([\d\.]+)\s\[ms\]\s\(mean\)/)
    end

    def self.queries_per_second
      safe_integer(/Requests per second:\s*([\d\.]+)\s\[#\/sec\]\s\(mean\)/)
    end

    def self.transfer_rate
      safe_integer(/Transfer rate:\s*([\d\.]+)\s\[Kbytes\/sec\]/)
    end

    def self.failed_requests
      safe_integer(/Failed requests:\s*([\d\.]+)/)
    end

    def self.non_2xx
      safe_integer(/Non-2xx responses:\s*([\d\.]+)/)
    end

    def self.keep_alive
      safe_integer(/Keep-Alive requests:\s*([\d\.]+)/)
    end

    def self.percent_served_within(percent)
      safe_integer(/#{percent}\s*([\d]+)/)
    end

    def self.log(raw)
      @raw = raw
      queries = %w(avg_response_time queries_per_second transfer_rate
                   failed_requests non_2xx keep_alive)
      results_hash =
        {}.tap do |hash|
          queries.each do |name|
            hash[name.to_sym] = Capacity::Result.send(name)
          end
        end

      percentages = [50, 66, 75, 80, 90, 95, 98, 99, 100]
      percentages.each do |int|
        results_hash["percent_#{int}".to_sym] = percent_served_within("#{int}%")
      end
      results_hash[:longest_request] = results_hash[:percent_100]
      Capacity::CapConfig.symbolize_keys(results_hash)
    end

    def self.safe_integer(reg_ex)
      content = @raw.match(reg_ex)
      content[1].to_i if content && content.size >= 2
    end
  end
end
