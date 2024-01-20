include Pagy::Backend

module PaginationHelper
  def self.humanize_pagination(data, pagination)
    {
      pagination: {
        prev_url: pagination[:prev],
        next_url: pagination[:next],
        count: pagination[:count],
        page: pagination[:page],
        next: pagination[:next]
      },
      data: data
    }
  end
end