# frozen_string_literal: true

Rails.application.routes.draw do
  resources :questionnaires, only: %i[show new create], param: :title
end
