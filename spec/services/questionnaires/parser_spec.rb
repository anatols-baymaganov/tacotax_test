# frozen_string_literal: true

require "rails_helper"

Rails.describe Questionnaires::Parser, type: :service do
  let(:yaml) { File.open("spec/support/examples/good.yml") }
  let(:service) { described_class.new(yaml) }

  describe "#call" do
    let(:results) { service.call.elements }
    let(:parent_element) { results[9] }
    let(:response_element) { results[13] }
    let(:references) { results.map { |el| el.reference&.value }.compact }
    let(:expected_references) do
      %w[questionnaire_example slide1 first_name last_name slide2
         family_situation maried slide3 revenue_type revenue_amount]
    end

    it "should create 15 elements" do
      expect(results.count).to eq(15)
    end

    it "should create referenced elements" do
      expect(references).to match_array(expected_references)
    end

    it "should create elements with response elements" do
      expect(parent_element.content.value.size).to eq(3)
    end

    it "should create response elements with parents" do
      expect(response_element.parent).to eq(parent_element)
    end
  end
end
