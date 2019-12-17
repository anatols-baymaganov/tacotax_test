# frozen_string_literal: true

require "rails_helper"

Rails.describe QuestionnaireContract do
  let(:reference) { "blah" }
  let(:body) { YAML.load_file(filename) }
  let(:contract) { described_class.new }
  let(:errors) do
    contract.call(reference: reference, body: body).errors(full: true).map do |err|
      err.text.split("\n")
    end.flatten
  end

  describe "#call" do
    context "when good.yml file is uploaded" do
      let(:filename) { "spec/support/examples/good.yml" }

      it "should return zero errors" do
        expect(errors).to be_empty
      end
    end

    context "when reference is empty" do
      let(:reference) { nil }
      let(:filename) { "spec/support/examples/good.yml" }

      it "should return error" do
        expect(errors).to include("reference must be filled")
      end
    end

    context "when bad.yml file is uploaded" do
      let(:filename) { "spec/support/examples/bad.yml" }
      let(:expected_errors) do
        [
          "Line: 11: text_input should contain label field",
          "Line: 13: slide should contain reference field",
          "Line: 17: single_choice should contain at least one content",
          "Line: 25: undefined element type",
          "Line: 26: slide should contain label field",
          "Line: 29: multiple_choice should contain reference field",
          "Line: 36: response element should contain value field",
          "Line: 37: number_input should contain reference field",
          "Line: 37: number_input should contain label field"
        ]
      end

      it "should return a lot of errors" do
        expect(errors).to match_array(expected_errors)
      end
    end
  end
end
