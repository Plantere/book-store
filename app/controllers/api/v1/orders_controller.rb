class Api::V1::OrdersController < ApplicationController
  before_action :authorize_request
  
  def create
    if BooksService.any_books_below_ordered_quantity?(params_order_details)
      render json: { error: "Invalid book quantities in the order." }, status: :unprocessable_entity
      return
    end

    order = Order.new(price: 0, user_id: @current_user[:id], **params_order)
    if order.save
      params_order_details.each do |order_detail|
        price_book = BooksService.get_price_book(order_detail[:book_id])
        order.price += price_book * order_detail[:quantity]

        order_detail = OrderDetail.new(price: price_book, order_id: order[:id], **order_detail)
        order_detail.save

        BooksService.decrease_stock_quantity(order_detail[:book_id], order_detail[:quantity])
      end

      order.save
      
      render json: { message: "Order created successfully" }, status: :ok
      return
    end

    render json: { error: order.errors.full_messages }, status: :ok
    return
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
