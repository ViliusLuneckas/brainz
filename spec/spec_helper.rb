require 'rspec'
require 'mocha'
require_relative '../lib/brainz'

RSpec.configure do |config|
  config.mock_with :mocha
end