module AuthorsHelper
  def self.get_filtered(filter)
    authors = Author

    if(filter[:search] != nil)
      authors = authors.where('LOWER(authors.full_name) LIKE :search', {search: "%" + Book.sanitize_sql_like(filter[:search].downcase) + "%"})
    end

    authors
  end
end