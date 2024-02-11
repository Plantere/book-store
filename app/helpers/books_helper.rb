module BooksHelper
  def self.get_filtered_books(filter)
    books = Book.joins(:publisher, :author, :genre)

    if(filter[:search] != nil)
      books = books.where("LOWER(books.name) LIKE :search_term OR LOWER(publishers.name) LIKE :search_term OR LOWER(authors.full_name) LIKE :search_term OR LOWER(genres.name) LIKE :search_term", {search_term: "%" + Book.sanitize_sql_like(filter[:search].downcase) + "%"})
    end

    if(filter[:genre] != nil)
      books = books.where("LOWER(genres.name) = ?", Book.sanitize_sql_like(filter[:genre].downcase))
    end

    if(filter[:stock] != nil)
      books = books.where(filter[:stock].to_i == 1 ? "books.stock_quantity >= 1" : "books.stock_quantity = 0")
    end

    if(filter[:status] != nil)
      books = books.where("books.status = ?", Book.sanitize_sql_like(filter[:status].downcase))
    end

    books
  end

  def self.check_books_in_cart(cart)
    Book.where(id: cart.map{|item| item[:book_id]}).count == cart.count
  end
  
  def self.books_below_ordered(books)
    conditions = books.map { |condition| "(id = ? AND stock_quantity < ?)" }
    conditions_string = conditions.join(" OR ")
    
    conditions_hash = books.flat_map { |condition| [condition[:book_id], condition[:quantity]] }

    Book.where(conditions_string, *conditions_hash)
  end
  
  def self.get_price_book(book_id)
    return Book.find(book_id).price
  end

  def self.decrease_stock_quantity(book_id, decrease_by)
    return Book.find(book_id).decrement!(:stock_quantity, decrease_by)
  end
end
