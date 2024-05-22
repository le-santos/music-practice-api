class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!

  private

  def user_not_authorized
    flash[:alert] = I18n.t('not_authorized', scope: 'pundit', default: :default)
    redirect_back(fallback_location: root_path)
  end
end
