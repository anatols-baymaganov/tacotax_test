# frozen_string_literal: true

module Questionnaires
  class Parser
    def initialize(file)
      @hsh = YAML.load_stream(LineNumerizer.call(file)).first
    end

    def call
      @call ||= extract_element(hsh)
    end

    private

    attr_reader :hsh

    def extract_element(hash, elements = [])
      reference = extract_field(hash, "reference")
      type = extract_field(hash, "type")
      label = extract_field(hash, "label")
      value = extract_field(hash, "value")
      content = extract_field(hash, "content")
      content&.value.to_a.map! do |h|
        extract_element(h, elements)
        elements.last
      end

      elements << Element.new(reference, type, label, value, content)
      elements.last
    end

    def extract_field(hash, name)
      line = nil
      value = hash.detect do |key, _|
        n, line = Field.extract_name_line(key)
        n == name
      end&.second
      return if value.blank?

      Field.new(name, value, line)
    end
  end
end
