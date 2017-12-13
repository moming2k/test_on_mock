class Country < ActiveResource::Base
    self.site = "http://restcountries.eu/"
    # self.proxy = "http://127.0.0.1:8888" # use proxy for development

    def self.find_by_name(name)
        params = {:name => name}
        begin
            self.find(:all, :params => params) || []
        rescue ActiveResource::ServerError => e
            Rails.logger.warn { "Encountered a non-fatal ServerError error for: #{name}" }
            return []
        rescue => e
            Rails.logger.error { "Encountered an error when trying to find Country for: #{name}, #{e.message} #{e.backtrace.join("\n")}" }
            return []
        end
    end

    class << self
        def collection_path(prefix_options = {}, query_options = nil)
            prefix_options, query_options = split_options(prefix_options) if query_options.nil?
            "/rest/v2/name/#{query_options[:name]}?fullText=true"
        end
    end
end