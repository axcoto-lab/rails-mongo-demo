ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
#require 'minitest/rails'
require 'minitest/mock'
require 'webmock/minitest'
require 'minitest/spec'
#require 'mocha/mini_test'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
