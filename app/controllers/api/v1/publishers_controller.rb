class Api::V1::PublishersController < ApplicationController
  before_action :authorize_request, only: [ :create ]
  before_action :is_admin, only: [ :create ]
  
  def index
    render json: Publisher.all
  end

  def create
    if Publisher.exists?(name: params_publisher[:name])
      render json: { error: "Publisher already exists" }, status: :unprocessable_entity
      return
    end

    publisher = Publisher.new(params_publisher)
    if publisher.save
      render json: { message: "Publisher created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create publisher. Please check the provided data." }, status: :unprocessable_entity
  end

  def delete
    if !Publisher.exists?(params[:id])
      render json: { error: "Publisher not found" }, status: :unprocessable_entity
      return;
    end

    Publisher.destroy(params[:id])

    render json: { message: "Publisher deleted successfully" }, status: :ok
  end

  private
  def params_publisher
    params.require(:publisher).permit(:name, :description)
  end
end
