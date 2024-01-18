require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publisher = Publisher.new(name: "Bloomsbury Publishing Rocco", description: '...')
    @genre = Genre.new(name: "Romance", description: 'Just a romance!')
    @author = Author.new(full_name: "Martin Luther King", birth_date: '1965-07-31', biography: 'He was someone in the world')

    @publisher.save
    @genre.save
    @author.save
  end

  test "should create a book and return success" do
    post "/api/v1/book", params: {
      name: "Harry Potter and the Philosopher's Stone",
      description: "...",
      publisher_id: @publisher.id,
      genre_id: @genre.id,
      author_id: @author.id
    }, as: :json

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    assert Book.exists?(name: "Harry Potter and the Philosopher's Stone", description: "...", publisher_id: @publisher.id, genre_id: @genre.id, author_id: @author.id)
  end
end
