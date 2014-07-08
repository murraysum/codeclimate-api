require 'date'

require "codeclimate-api/version"
require "codeclimate-api/configuration"
require "codeclimate-api/client"
require "codeclimate-api/request"
require "codeclimate-api/repository"
require "codeclimate-api/snapshot"

module Codeclimate
  module Api

    # Public: Configure the Code Climate API and set
    # an access token to authenticate.
    #
    # Examples:
    #
    #  CodeClimate::Api.configure do |c|
    #    c.access_token = "xxxxxxxxxxxxxxxxxxxx"
    #  end
    def self.configure
      @configuration = Codeclimate::Api::Configuration.new
      yield @configuration
    end

    # Public: Query the Code Climate API directly.
    def self.client
      Codeclimate::Api::Client.new(@configuration.access_token)
    end
  end
end
