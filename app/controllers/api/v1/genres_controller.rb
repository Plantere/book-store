class Api::V1::GenresController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: [ :create, :update, :get_all ]
  before_action :is_admin, only: [ :create, :update, :get_all ]
  
  def index
    render json: Genre.all
  end

  def create
    if Genre.exists?(name: params_genre[:name])
      render json: { error: "Genre already exists" }, status: :unprocessable_entity
      return
    end

    genre = Genre.new(params_genre)
    if genre.save
      render json: { message: "Genre created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create genre. Please check the provided data." }, status: :unprocessable_entity
  end

  def get_all
    render json: {
      data: Genre.all.map{ |genre| {
        id: genre[:id],
        name: genre[:name]
      }}
    }
  end

  def update 
    if !Genre.exists(id: params[:genre_id])
      render json: { error: "Genre not found" }, status: :unprocessable_entity
      return
    end

    genre = Genre.find(params[:genre_id])
    if genre.update(params_genre)
      render json: { message: "Genre updated successfully" }, status: :ok
      return
    end
    
    render json: { error: "Failed to updated genre. Please check the provided data." }, status: :unprocessable_entity
  end

  def delete
    if !Genre.exists?(params[:genre_id])
      render json: { error: "Genre not found" }, status: :unprocessable_entity
      return;
    end

    Genre.destroy(params[:genre_id])

    render json: { message: "Genre deleted successfully" }, status: :ok
  end

  private
  def params_genre
    params.require(:genre).permit(:name, :description)
  end
end
