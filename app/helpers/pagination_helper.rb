include Pagy::Backend

module PaginationHelper
  def self.humanize_pagination(data, pagination, associations = [])
    {
      pagination: pagination.slice(:prev_url, :next_url, :count, :page),
      data: data.map do |item|
        {**item.attributes, **associations.to_h { |association| [association, item.send(association)] }}
      end
    }
  end
end