require 'net/http'
require 'uri'
require 'json'

module Codeclimate
  module Api
    class Client

      attr_reader :access_token

      def initialize(access_token)
        @access_token = access_token
      end

      def get(path, options = {})
        response = request(path, options)
        JSON.parse(response.body, :symbolize_names => true)
      end

      def post(path, options = {})

      end

      private

      def request(path, options = {})
        uri = build_uri(path, options)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        puts uri

        request = Net::HTTP::Get.new(uri.request_uri)

        response = http.request(request)
      end

      def build_uri(path, opts)
        uri = URI.join(host, path)
        uri.query = build_query(opts)
        uri
      end

      def build_query(opts)
        URI.encode_www_form(opts.merge({:api_token => access_token}))
      end

      def host
        "https://codeclimate.com/api/"
      end
    end
  end
end