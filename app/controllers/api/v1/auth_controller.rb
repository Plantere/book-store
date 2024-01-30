class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: [:get_authenticate_profile]
  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token }, status: :ok
      return
    end

    render json: { error: "Incorrect email or password. Please check your credentials and try again." }, status: :unauthorized
  end


  def get_authenticate_profile
    @user = User.find(@current_user[:id])
    @user_profile = @current_user.profile

    render json: {
      data: {
        profile: {
          first_name: @user_profile[:first_name],
          last_name: @user_profile[:last_name],
          avatar: @user_profile[:avatar],
          birth_date: @user_profile[:birth_date],
          description: @user_profile[:description],
        },
        user: {
          username: @current_user[:username],
          email: @current_user[:email]
        }
      }
    }
  end

  private
  def login_params
    params.permit(:email, :password)
  end
end
