module BookImagesHelper
  def self.create_image(book, images)
    images.each do |image|
      next if book.book_image.exists?(token_image: image[:token_image])

      book.book_image.create({
        path: image[:url],
        is_default: image[:is_default],
        token_image: image[:token_image]
      })
    end
  end
end