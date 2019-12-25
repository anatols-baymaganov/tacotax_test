# frozen_string_literal: true

module Questionnaires
  class Element
    ATTRIBUTES = %i[reference type label value content parent].freeze

    def initialize(reference, type, label, value, content)
      @reference = reference
      @type = type
      @label = label
      @value = value
      @content = content
      @parent = nil

      content.value&.each { |element| element.parent = self } if content.present?
    end

    attr_reader(*ATTRIBUTES)

    def [](key)
      return unless key.to_sym.in?(ATTRIBUTES)

      public_send(key).value
    end

    def as_json
      return @as_json if defined?(@as_json)

      @as_json = [reference, type, label, value].compact.map(&:as_json).inject({}, :merge)
                                                .merge("content" => content&.value&.map(&:as_json))
                                                .compact
    end

    def elements
      return @elements if defined?(@elements)

      @elements = content&.value.to_a.each_with_object([]) { |content, arr| arr << content.elements }.flatten << self
      @elements.sort! { |a, b| a.line <=> b.line }
    end

    def line
      @line ||= [reference, type, label, value, content].compact.map(&:line).min
    end

    protected

    attr_writer :parent
  end
end
