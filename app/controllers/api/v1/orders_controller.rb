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
    page, data = pagy(Order.where(user_id: @current_user[:id]).includes(:order_detail).all, page: params[:page])
    pagination = pagy_metadata(page)

    render json: PaginationHelper.humanize_pagination(data, pagination, [:order_detail]), status: :ok
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
