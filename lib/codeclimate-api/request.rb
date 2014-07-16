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

      def self.create(path)
        request = Codeclimate::Api::Request.new(path, nil)
        request.create
      end

      def create
        response = Codeclimate::Api.client.post(@path)
        response.code == "200"
      end
    end
  end
end