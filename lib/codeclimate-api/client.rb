module Codeclimate
  module Api
    class Client

      attr_reader :access_token

      # Internal: Build an API client to communicate
      # with the Code Climate API.
      #
      # access_token - the token to access the API.
      #
      # Returns an instance of Codeclimate::Api::Client
      def initialize(access_token)
        @access_token = access_token
      end

      # Internal: Perform a HTTPS GET for the given path
      #
      # path - the path to request
      # opts - a hash of query parameters to send.
      #
      # Returns JSON
      def get(path, opts = {})
        request('GET', path, opts)
      end

      # Internal: Perform a HTTPS POST for the given path
      #
      # path - the path to request.
      # opts - a hash of query parameters to send.
      #
      # Returns the response from the API.
      def post(path, opts = {})
        request('POST', path, opts)
      end

      private

      # Private: Perform a HTTPS request for the Code
      # Climate API.
      #
      # type - the type of HTTPS request to perform.
      # path - the path to request.
      # opts - a hash of query parameters to be sent.
      #
      # Returns the response from the API.
      def request(type, path, opts = {})
        uri = build_uri(path, opts)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        puts uri

        http.send_request(type, uri.request_uri)
      end

      # Private: Build the URI to be requested.
      #
      # path - the path to be requested.
      # opts - a hash of query parameters to be sent.
      #
      # Returns the URI
      def build_uri(path, opts)
        uri = URI.join(host, path)
        uri.query = build_query(opts)
        uri
      end

      # Private: Build the query parameters required
      # to perform a request.
      #
      # opts - a hash of query parameters to be sent.
      #
      # Returns encoded query parameters.
      def build_query(opts)
        URI.encode_www_form(opts.merge({:api_token => access_token}))
      end

      # Private: The hostname of the Code Climate API.
      #
      # Returns the hostname as a String.
      def host
        "https://codeclimate.com/api/"
      end
    end
  end
end