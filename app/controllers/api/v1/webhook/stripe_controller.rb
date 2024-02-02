class Api::V1::Webhook::StripeController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    event = Stripe::Event.construct_from(
      JSON.parse(request.body.read, symbolize_names: true)
    )

    if event.type === "payment_intent.payment_failed"
      OrdersHelper.set_order_to_status(event.data.object.id, 4)
    elsif event.type === "payment_intent.succeeded"
      OrdersHelper.set_order_to_status(event.data.object.id, 3)
    end

    render json: {
      message: "Order updated successfully",
    }, status: :ok
  end
end