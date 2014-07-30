require 'rspec'
require 'factory_girl'
require 'codeclimate-api'

RSpec.configure do |config|
  config.color_enabled = true
end

FactoryGirl.find_definitions