# frozen_string_literal: true

class QuestionnaireContract < Dry::Validation::Contract
  params do
    required(:reference).filled(:string)
    required(:body).filled
  end

  rule(:body) do
    elements = Questionnaires::ElementsExtractor.new(value).extract
    errors = elements.map { |element| validate_element(element) }.flatten
    key.failure(errors.join("\n")) if errors.any?
  end

  private

  def validate_element(element)
    @errors = []

    case element.type&.value
    when "questionnaire"
      @errors << "Line: #{element.line}: questionnaire should contain reference field" if param_blank?(element, :reference)
      @errors << "Line: #{element.line}: questionnaire should contain content" if param_blank?(element, :content)
    when "slide" then should_contain_ref_lbl_content(element)
    when "text_input" then should_contain_ref_and_lbl(element)
    when "number_input" then should_contain_ref_and_lbl(element)
    when "boolean" then should_contain_ref_and_lbl(element)
    when "single_choice" then should_contain_ref_lbl_content(element)
    when "multiple_choice" then should_contain_ref_lbl_content(element)
    when nil then check_if_response_element(element)
    else @errors << "Line: #{element.type.line}: undefined element type"
    end
    @errors
  end

  def should_contain_ref_and_lbl(element)
    @errors << "Line: #{element.line}: #{element.type.value} should contain reference field" if param_blank?(element, :reference)
    @errors << "Line: #{element.line}: #{element.type.value} should contain label field" if param_blank?(element, :label)
  end

  def should_contain_ref_lbl_content(element)
    should_contain_ref_and_lbl(element)
    return unless param_blank?(element, :content)

    @errors << "Line: #{element.line}: #{element.type.value} should contain at least one content"
  end

  def check_if_response_element(element)
    if response_element?(element)
      @errors << "Line: #{element.line}: response element should contain label field" if param_blank?(element, :label)
      @errors << "Line: #{element.line}: response element should contain value field" if param_blank?(element, :value)
    else
      @errors << "Line: #{element.line}: element should have type field"
    end
  end

  def param_blank?(element, param)
    element.public_send(param)&.value.blank?
  end

  def response_element?(element)
    element.parent.type.value.in?(%w[single_choice multiple_choice])
  end
end
