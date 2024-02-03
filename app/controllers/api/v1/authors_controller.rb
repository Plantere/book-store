class Api::V1::AuthorsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: [ :create, :update ]
  before_action :is_admin, only: [ :create, :update ]

  def index
    render json: Author.all
  end

  def create
    if Author.exists?(full_name: params_author[:full_name])
      render json: { error: "Author already exists" }, status: :unprocessable_entity
      return
    end

    author = Author.new(params_author)
    if author.save
      render json: { message: "Author created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create author. Please check the provided data." }, status: :unprocessable_entity
  end

  def get_all
    render json: {
      data: Author.all.map{ |author|  {
        id: author[:id],
        full_name: author[:full_name],
      }}
    }
  end

  def update 
    if !Author.exists(id: params[:author_id])
      render json: { error: "Author not found" }, status: :unprocessable_entity
      return
    end

    author = Author.find(params[:author_id])
    if author.update(params_author)
      render json: { message: "Author updated successfully" }, status: :ok
      return
    end
    
    render json: { error: "Failed to updated author. Please check the provided data." }, status: :unprocessable_entity
  end

  def delete
    if !Author.exists?(params[:author_id])
      render json: { error: "Author not found" }, status: :unprocessable_entity
      return;
    end

    Author.destroy(params[:author_id])

    render json: { message: "Author deleted successfully" }, status: :ok
  end

  private
  def params_author
    params.require(:author).permit(:full_name, :birth_date, :biography)
  end
end
