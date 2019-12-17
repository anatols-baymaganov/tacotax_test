# frozen_string_literal: true

require "rails_helper"

Rails.describe Questionnaires::Creator, type: :service do
  let(:service) { described_class.new(body: file) }

  describe "#call" do
    context "when good.yml file is uploaded" do
      let(:file) { File.open("spec/support/examples/good.yml") }

      context "and Questionnaire is not created" do
        it "should create new Questionnaire" do
          expect { service.call }.to change { Questionnaire.count }.by(1)
        end
      end

      context "and Questionnaire has already created" do
        before { service.call }

        it "should not create Questionnaire" do
          expect { service.call }.not_to change { Questionnaire.count }
        end
      end
    end

    context "when incorrect.yml file is uploaded" do
      let(:file) { File.open("spec/support/examples/incorrect.yml") }

      it "should return error" do
        expect { service.call }.to change { service.errors }.from([]).to(["Incorrect file format"])
      end
    end
  end
end
