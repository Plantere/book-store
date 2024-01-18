require "test_helper"

class GenresControllerTest < ActionDispatch::IntegrationTest
  test "should create a genre and return success" do
    post "/api/v1/genre", params: { name: "Mystery", description: "An intriguing genre." }, as: :json

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    assert Genre.exists?(name: "Mystery", description: "An intriguing genre.")
  end

  test "should delete a genre and return success" do
    @genre = Genre.new(name: "Romance", description: 'Just a romance!')
    @genre.save

    delete "/api/v1/genre/#{@genre.id}"

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    assert_not Genre.exists?(@genre.id)
  end
end
