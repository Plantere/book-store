class Api::V1::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request
  
  def create
    if BooksHelper.books_below_ordered(params[:cart]).exists?
      render json: {
        error: "Invalid book quantities in the order",
        data: BooksHelper.books_below_ordered(params[:cart]).all.map{ |book| {
          id: book[:id],
          stock_quantity: book[:stock_quantity]
        }}
      }, status: :unprocessable_entity
      return
    end

    address = Address.where(id: params[:address], user_id: @current_user[:id]).first
    if !address
      render json: {
        error: "Address provided is invalid to process transaction"
      }, status: :unprocessable_entity
      return
    end

    order_intent = OrdersHelper.create_order_intent(params[:cart], address, params[:carrier], @current_user)

    render json: {
      message: "Order created successfully",
      client_secret: order_intent[:client_secret]
    }, status: :ok
  end

  def get
    page, data = pagy(Order.where(user_id: @current_user[:id]).where.not(status: 4).includes(:address, order_detail: :book).order(created_at: :desc).all, page: params[:page], items: 5)
    pagination = pagy_metadata(page)

    render json: {
      pagination: pagination.slice(:prev_url, :next_url, :count, :page),
      data: data.map do |item|
        {
          id: item.id,
          price: item.price,
          description: item.description,
          status: item.status,
          created_at: item.created_at,
          details: item.order_detail.map do |detail|
            {
              name: detail.book.name,
              image: "https://m.media-amazon.com/images/I/616U6mSP3lL._SL1000_.jpg",
              price: detail.price,
              quantity: detail.quantity,
            }
          end,
          address: {
            name: item.address.name,
            street: item.address.street,
            district: item.address.district,
            number: item.address.number,
          }
        }
      end
    }, status: :ok
  end

  def params_order_details
    params.require(:order_details).map do |order_detail|
      order_detail.permit(:book_id, :quantity)
    end
  end
  def params_order
    params.require(:order).permit(:address_id, :description)
  end
end
