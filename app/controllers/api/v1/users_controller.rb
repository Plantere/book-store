class Api::V1::UsersController < ApplicationController
  def register
    if User.registered?(user_params)
      render json: { error: "User already registered. Duplicates are not allowed." }, status: :unprocessable_entity
      return
    end

    @user = User.new(user_params)
    if @user.save
      @user.create_profile(profile_params)
      render json: { "message": "User created successufly" }, status: :ok
      return
    end

    render json: { error: "Error creating user. Please check the provided data." }, status: :unprocessable_entity
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :birth_date, :description)
  end
end
