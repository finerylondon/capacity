module Capacity
  module Page
    def self.get_url(page, force_new = false)
      if force_new || !page[:testing_url]
        url = page[:url]
        url = url.call if url.respond_to? :call
        page[:testing_url] = url
      else
        url = page[:testing_url]
      end
      url
    end

    def self.get_display_url(page)
      if page[:url].respond_to? :call
        return "Dynamic url example: #{page[:url].call}"
      else
        page[:url]
      end
    end
  end
end
