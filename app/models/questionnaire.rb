# frozen_string_literal: true

class Questionnaire
  class << self
    def set(reference, body)
      redis.set(reference, body.to_json)
    end

    def get(reference)
      JSON.parse(redis.get(reference))
    end

    def count
      redis.keys.count
    end

    private

    def redis
      @redis ||= Redis.new(url: ENV["REDIS_URL"] || "redis://redis:6379/0")
    end
  end
end
