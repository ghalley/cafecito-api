class ApplicationController < ActionController::API
  helper_method :authenticate

  def authenticate
    unless params['token'].present? && params['token'] == Rails.application.secrets.slack_token
      head :forbidden
    end
  end
end
