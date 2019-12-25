# frozen_string_literal: true

module Questionnaires
  class Creator
    def initialize(args)
      @file = args[:body]
      @contract = QuestionnaireContract.new
      @errors = []
    end

    attr_reader :errors

    def call
      @errors = contract.call(reference: reference, body: parsed_data.elements).errors(full: true).map do |err|
        err.text.split("\n")
      end.flatten.map(&:capitalize)
      return if @errors.any?

      Questionnaire.set(reference, parsed_data.as_json)
    rescue Psych::SyntaxError => _e
      @errors |= Array.wrap("Incorrect file format")
      nil
    rescue StandardError => e
      @errors |= Array.wrap("Internal server error: #{e.message}")
      nil
    end

    private

    attr_reader :file, :contract

    def parsed_data
      @parsed_data ||= Parser.new(file).call
    end

    def reference
      parsed_data["reference"]
    end
  end
end
