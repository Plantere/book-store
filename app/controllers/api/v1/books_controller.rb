class Api::V1::BooksController < ApplicationController
  def index
    render json: Book.all
  end

  def create
    if Book.exists?(name: params_book[:name], publisher_id: params_book[:publisher_id], author_id: params_book[:author_id])
      render json: { error: "Book already exists" }, status: :unprocessable_entity
      return
    end

    book = Book.new(params_book)
    if book.save
      render json: { message: "Book created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create book. Please check the provided data." }, status: :unprocessable_entity
  end

  private
  def params_book
    params.require(:book).permit(:name, :description, :price, :stock_quantity, :publisher_id, :author_id, :genre_id)
  end
end
