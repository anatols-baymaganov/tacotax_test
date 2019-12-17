# frozen_string_literal: true

module Questionnaires
  class ElementsExtractor
    def initialize(hash)
      @hash = hash
    end

    def extract
      @fields = []
      extract_element(hash.deep_dup).sort! { |a, b| a.line <=> b.line }
    end

    private

    attr_reader :hash, :fields

    def extract_element(hsh, elements = [])
      reference = extract_field(hsh, "reference")
      type = extract_field(hsh, "type")
      label = extract_field(hsh, "label")
      value = extract_field(hsh, "value")
      content = extract_field(hsh, "content")
      content&.value.to_a.map! do |h|
        extract_element(h, elements)
        elements.last
      end

      elements << Element.new(reference, type, label, value, content)
      elements
    end

    def extract_field(hsh, name)
      return unless hsh.key?(name)

      fields << Field.new(name, hsh[name], fields&.last&.line&.next || 1)
      fields.last
    end
  end
end
