class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, except: [:register]

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

  def update
    if User.where.not(id: @current_user[:id]).where("username = ? or email = ?", params_update_user[:username], params_update_user[:email]).exists?()
      render json: { error: "Email, or username already been used" }, status: :unprocessable_entity
      return
    end

    @current_user.update(**params_update_user)
    @current_user.profile.update(**params_update_profile)

    render json: { error: "User updated successufly" }, status: :ok
  end

  def change_password
    @current_user.update(**params_change_password)
    render json: { error: "Password changed successufly" }, status: :ok
  end

  private
  def params_user
    params.require(:user).permit(:username, :email, :password)
  end

  def params_profile
    params.require(:profile).permit(:first_name, :last_name)
  end

  def params_update_profile
    params.require(:profile).permit(:first_name, :last_name, :birth_date, :description)
  end

  def params_update_user
    params.require(:user).permit(:username, :email)
  end

  def params_change_password
    params.permit(:password)
  end
end
