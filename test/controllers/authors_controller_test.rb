require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  test "should create an author and return success" do
    post "/api/v1/author", params: {
      full_name: "Joanne Rowling",
      birth_date: "1965-07-31",
      biography: "Author of the Harry Potter series."
    }, as: :json

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    assert Author.exists?(full_name: "Joanne Rowling", birth_date: "1965-07-31", biography: "Author of the Harry Potter series.")
  end

  test "should delete an author and return success" do
    @author = Author.new(
      full_name: "Martin Luther King",
      birth_date: "1965-07-31",
      biography: "He was someone in the world"
    )
    author.save

    delete "/api/v1/author/#{author.id}"

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    assert_not Author.exists?(author.id)
  end
end
