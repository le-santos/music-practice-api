class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  before_action :authenticate_user!

  private

  def user_not_authorized
    flash[:alert] = I18n.t('user_not_authorized', scope: 'pundit', default: :default)
    redirect_back_or_to(root_path)
  end

  def parameter_missing
    flash[:error] = I18n.t(
      'parameter_missing',
      scope: 'actioncontroller.errors.messages'
    )

    redirect_back_or_to(root_path)
  end
end
