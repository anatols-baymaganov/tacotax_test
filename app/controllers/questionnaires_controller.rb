# frozen_string_literal: true

class QuestionnairesController < ApplicationController
  def show
    render json: Questionnaire.find_by(reference: params[:reference]).body
  end

  def create
    service = Questionnaires::Creator.new(questionnaire_params)

    if service.call.blank? || service.errors.any?
      flash[:alert] = service.errors
    else
      flash[:success] = "L'upload du questionnaire a réussi"
    end

    redirect_back(fallback_location: new_questionnaire_path)
  end

  private

  def questionnaire_params
    params.require(:questionnaire).permit(:body)
  end
end
