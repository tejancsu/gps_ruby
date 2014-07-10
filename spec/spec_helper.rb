$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler'
require 'gps'
require 'logger'
require 'rspec'
require 'uuidtools'

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
  config.formatter = 'documentation'
end
