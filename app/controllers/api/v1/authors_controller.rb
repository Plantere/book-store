class Api::V1::AuthorsController < ApplicationController
  def index
    render json: Author.all
  end

  def create
    if Author.exists?(full_name: params_author[:full_name])
      render json: { error: "Author already exists" }, status: :unprocessable_entity
      return
    end

    @author = Author.new(params_author)
    if @author.save
      render json: { message: "Author created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create author. Please check the provided data." }, status: :unprocessable_entity
  end

  def delete
    if !Author.exists?(params[:id])
      render json: { error: "Author not found" }, status: :unprocessable_entity
      return;
    end

    Author.destroy(params[:id])

    render json: { message: "Author deleted successfully" }, status: :ok
  end

  private
  def params_author
    params.require(:author).permit(:full_name, :birth_date, :biography)
  end
end
