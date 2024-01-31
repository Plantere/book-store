class Api::V1::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request
  
  def create
    if BooksHelper.any_books_below_ordered_quantity?(params_order_details)
      render json: { error: "Invalid book quantities in the order." }, status: :unprocessable_entity
      return
    end

    order = Order.new(price: 0, user_id: @current_user[:id], **params_order)
    if order.save
      params_order_details.each do |order_detail|
        price_book = BooksHelper.get_price_book(order_detail[:book_id])
        order.price += price_book * order_detail[:quantity]

        order_detail = OrderDetail.new(price: price_book, order_id: order[:id], **order_detail)
        order_detail.save

        BooksHelper.decrease_stock_quantity(order_detail[:book_id], order_detail[:quantity])
      end

      order.save
      
      render json: { message: "Order created successfully" }, status: :ok
      return
    end

    render json: { error: order.errors.full_messages }, status: :ok
    return
  end

  def get
    page, data = pagy(Order.where(user_id: @current_user[:id]).includes(:address, order_detail: :book).order(created_at: :desc).all, page: params[:page], items: 5)
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
