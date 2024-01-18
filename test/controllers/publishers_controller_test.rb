require "test_helper"

class PublishersControllerTest < ActionDispatch::IntegrationTest
  test "should create a publisher and return success" do
    post "/api/v1/publisher", params: {
      name: "Another Publisher",
      description: "Any description."
    }, as: :json

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    assert Publisher.exists?(name: "Another Publisher", description: "Any description.")
  end

  test "should delete a publisher and return success" do
    @publisher = Publisher.new(
      name: "Bloomsbury Publishing Rocco",
      description: "Bloomsbury Publishing plc is an independent publisher based in London known for literary novels. It is a constituent of the FTSE SmallCap Index. The company's growth in the last decade is primarily attributed to the Harry Potter series by J.K. Rowling."
    )
    @publisher.save

    delete "/api/v1/publisher/#{@publisher.id}"

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    assert_not Publisher.exists?(@publisher.id)
  end
end
