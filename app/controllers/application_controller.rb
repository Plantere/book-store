include Pagy::Backend

class ApplicationController < ActionController::Base
  def index
    render template: 'layouts/application'
  end
  
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue => e
      render json: { error: "You are not logged in. Please sign in to access the features" }, status: :unauthorized
    end
  end

  def is_admin
    if @current_user[:user_type] != UserTypeEnums::ADMIN
      render json: { error: "Access to this resource is restricted to administrators only." }, status: :unauthorized
    end
  end
end
