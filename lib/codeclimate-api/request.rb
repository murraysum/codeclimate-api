module Codeclimate
  module Api
    class Request

      # Internal: Build an API request for given path
      # and an optional handler.
      #
      # path - the path to make the API call.
      # handler - the handler to handle the API response.
      #
      # Returns an instance of Codeclimate::Api::Request.
      def initialize(path, handler)
        @path = path
        @handler = handler
      end

      # Internal: Build and perform an API request to find
      # a resource.
      def self.find(path, handler)
        request = Codeclimate::Api::Request.new(path, handler)
        request.find
      end

      # Internal: Build and perform an API request to find
      # a resource.
      def find
        response = Codeclimate::Api.client.get(@path)
        json = JSON.parse(response.body, :symbolize_names => true)
        @handler.call(json)
      end

      # Internal: Build and perform an API request to create
      # a resource.
      def self.create(path)
        request = Codeclimate::Api::Request.new(path, nil)
        request.create
      end

      # Internal: Build and perform an API request to create
      # a resource.
      def create
        response = Codeclimate::Api.client.post(@path)
        response.code == "200"
      end
    end
  end
end