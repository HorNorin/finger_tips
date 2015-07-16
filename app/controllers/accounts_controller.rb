class AccountsController < ApplicationController
  def activate
    user = User.find params[:user_id]
    if user.activation_token == params[:token]
      user.update_attributes account_activated: true, activation_token: nil
      flash[:success] = "Your account is now activated."
      redirect_to login_path
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
