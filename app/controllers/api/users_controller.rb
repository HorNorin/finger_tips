class Api::UsersController < ApplicationController
  def validate
    render json: User.where("email = ?", params[:email]).count == 0
  end
end
