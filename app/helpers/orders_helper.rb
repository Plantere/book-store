module OrdersHelper

  def self.set_order_to_status(transaction_id, status)
    order = Order.where(transaction_id: transaction_id).first
    order.update(status: status)
    if status === 3
      order.order_detail.each do |detail|
        BooksHelper.decrease_stock_quantity(detail[:book_id], detail[:quantity])
      end
    end
  end

  def self.create_order_intent(cart_items, address, carrier, user)
    order = user.order.create(address_id: address[:id])
    total_amount_cart = calculate_order_amount(order, cart_items, carrier)

    order_intent = Stripe::PaymentIntent.create(
      amount: (total_amount_cart * 100).to_i,
      currency: 'usd',
      automatic_payment_methods: {
        enabled: true,
      },
      shipping: {
        name: user.profile.first_name + " " + user.profile.last_name,
        phone: address[:phone_number],
        carrier: carrier == 1 ? "Standard" : "Free" ,
        address: {
          city: address[:city],
          country: address[:country],
          line1: address[:street] + ", " + address[:number] + " - " + address[:district] ,
          line2: address[:complement],
          postal_code: address[:postal_code],
          state: address[:state],
        }
      },
      receipt_email: user[:email]
    )

    order.update(transaction_id: order_intent.id, price: total_amount_cart)

    order_intent
  end
  

  private
    def self.calculate_order_amount(order, cart_items, carrier)
      books = Book.where(id: cart_items.map { |book| book[:book_id] }).index_by(&:id)
    
      total_amount = cart_items.sum do |item|
        book = books[item[:book_id]]
        order.order_detail.create(quantity: item[:quantity], price: book.price, book_id: book[:id])
        item[:quantity] * book.price
      end
    
      total_amount + get_shipping_value(carrier)
    end

    def self.get_shipping_value(carrier)
      carrier == 1 ? 5.00 : 0
    end
end
