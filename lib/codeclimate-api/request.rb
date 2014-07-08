module Codeclimate
  module Api
    class Request

      def initialize(path, handler)
        @path = path
        @handler = handler
      end

      def self.find(path, handler)
        request = Codeclimate::Api::Request.new(path, handler)
        request.find
      end

      def find
        response = Codeclimate::Api.client.get(@path)
        @handler.call(response)
      end
    end
  end
end