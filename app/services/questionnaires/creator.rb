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
      @errors = contract.call(reference: reference, body: body).errors(full: true).map do |err|
        err.text.split("\n")
      end.flatten.map(&:capitalize)
      return if @errors.any?

      Questionnaire.set(reference, body)
    rescue StandardError => _e
      @errors |= ["Incorrect file format"]
      nil
    end

    private

    attr_reader :file, :contract

    def parsed_data
      @parsed_data ||= YAML.load_file(file)
    end

    def reference
      parsed_data["reference"]
    end

    alias body parsed_data
  end
end
