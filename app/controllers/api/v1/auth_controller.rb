class Api::V1::AuthController < ApplicationController
  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token }, status: :ok
      return
    end

    render json: { error: @user }, status: :unauthorized
  end

  private
  def login_params
    params.permit(:email, :password)
  end
end
