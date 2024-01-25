class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register
    if User.registered?(params_user)
      render json: { error: "User already registered. Duplicates are not allowed." }, status: :unprocessable_entity
      return
    end

    user = User.new(params_user)
    if user.save
      user.create_profile(params_profile)
      render json: { "message": "User created successufly" }, status: :ok
      return
    end

    render json: { error: "Error creating user. Please check the provided data." }, status: :unprocessable_entity
  end

  private
  def params_user
    params.require(:user).permit(:username, :email, :password)
  end

  def params_profile
    params.require(:profile).permit(:first_name, :last_name, :birth_date, :description)
  end
end
