class Api::V1::PublishersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: [ :create, :update, :get_all ]
  before_action :is_admin, only: [ :create, :update, :get_all ]
  
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

  def get_all
    render json: {
      data: Publisher.all.map{ |publisher|  {
        id: publisher[:id],
        name: publisher[:name],
      }}
    }
  end

  def update 
    if !Publisher.exists(id: params[:publisher_id])
      render json: { error: "Publisher not found" }, status: :unprocessable_entity
      return
    end

    publisher = Publisher.find(params[:publisher_id])
    if publisher.update(params_publisher)
      render json: { message: "Publisher updated successfully" }, status: :ok
      return
    end
    
    render json: { error: "Failed to updated publisher. Please check the provided data." }, status: :unprocessable_entity
  end

  def delete
    if !Publisher.exists?(params[:publisher_id])
      render json: { error: "Publisher not found" }, status: :unprocessable_entity
      return;
    end

    Publisher.destroy(params[:publisher_id])

    render json: { message: "Publisher deleted successfully" }, status: :ok
  end

  private
  def params_publisher
    params.require(:publisher).permit(:name, :description)
  end
end
