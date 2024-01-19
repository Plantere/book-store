module BooksService
  def self.any_books_below_ordered_quantity?(books)
    conditions = books.map { |condition| "(id = ? AND stock_quantity < ?)" }
    conditions_string = conditions.join(" OR ")
    
    conditions_hash = books.flat_map { |condition| [condition[:book_id], condition[:quantity]] }

    Book.where(conditions_string, *conditions_hash).exists?
  end
  
  def self.get_price_book(book_id)
    return Book.find(book_id).price
  end

  def self.decrease_stock_quantity(book_id, decrease_by)
    return Book.find(book_id).decrement!(:stock_quantity, decrease_by)
  end
end
