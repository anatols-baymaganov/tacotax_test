# frozen_string_literal: true

module Questionnaires
  class Field
    def initialize(name, value, line)
      @name = name
      @value = value
      @line = line
    end

    attr_reader :name, :value, :line
  end
end
