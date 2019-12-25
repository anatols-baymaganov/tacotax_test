# frozen_string_literal: true

module Questionnaires
  class Field
    def self.extract_name_line(key)
      splitted = key.split("-")
      line = splitted.pop if /\A\d+\z/.match(splitted.last)
      [splitted.join(LineNumerizer::DELIMITER), line]
    end

    def initialize(name, value, line)
      @name = name
      @value = value
      @line = line
    end

    def as_json
      { name => value }
    end

    attr_reader :name, :value, :line
  end
end
