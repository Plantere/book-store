class Api::V1::GenresController < ApplicationController
  before_action :authorize_request, only: [ :create ]
  before_action :is_admin, only: [ :create ]
  
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

  def delete
    if !Genre.exists?(params[:id])
      render json: { error: "Genre not found" }, status: :unprocessable_entity
      return;
    end

    Genre.destroy(params[:id])

    render json: { message: "Genre deleted successfully" }, status: :ok
  end

  private
  def params_genre
    params.require(:genre).permit(:name, :description)
  end
end
