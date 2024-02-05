module PublishersHelper
  def self.get_filtered(filter)
    publishers = Publisher

    if(filter[:search] != nil)
      publishers = publishers.where('LOWER(publishers.name) LIKE :search', {search: "%" + Book.sanitize_sql_like(filter[:search].downcase) + "%"})
    end

    publishers
  end
end