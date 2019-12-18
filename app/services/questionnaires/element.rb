# frozen_string_literal: true

module Questionnaires
  class Element
    def initialize(reference, type, label, value, content)
      @reference = reference
      @type = type
      @label = label
      @value = value
      @content = content
      @parent = nil

      content.value&.each { |element| element.parent = self } if content.present?
    end

    attr_reader :reference, :type, :label, :value, :content, :parent

    def line
      @line ||= [reference, type, label, value, content].compact.map(&:line).min
    end

    protected

    attr_writer :parent
  end
end
