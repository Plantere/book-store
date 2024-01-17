class ApplicationController < ActionController::API
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
end
