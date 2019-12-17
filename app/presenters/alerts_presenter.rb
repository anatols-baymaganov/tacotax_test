# frozen_string_literal: true

class AlertsPresenter
  class << self
    def alert_caption(type)
      case type.to_sym
      when :alert then "Error: "
      when :success then "Success: "
      else ""
      end
    end
  end
end
