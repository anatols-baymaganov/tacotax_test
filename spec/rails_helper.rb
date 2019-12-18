# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["REDIS_URL"] = "redis://redis:6379/15"

require File.expand_path("../../config/environment", __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "spec_helper"
require "rspec/rails"
require "simplecov"

SimpleCov.start

Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |file| require file }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.before(:each) { Redis.new(url: ENV["REDIS_URL"]).flushdb }
end
