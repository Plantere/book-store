
require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create user with valid params" do
    post api_v1_register_path, params: {
      user: {
        username: 'john_doe',
        email: 'john@example.com',
        password: 'password'
      },
      profile: {
        first_name: 'John',
        last_name: 'Doe',
        birth_date: '1990-01-01',
        description: 'Some description'
      }
    }

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'
  end

  test "should not create user with duplicate informations" do
    post api_v1_register_path, params: {
      user: {
        username: 'john_doe',
        email: 'john@example.com',
        password: 'password'
      },
      profile: {
        first_name: 'John',
        last_name: 'Doe',
        birth_date: '1990-01-01',
        description: 'Some description'
      }
    }

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'message'

    post api_v1_register_path, params: {
      user: {
        username: 'john_doe',
        email: 'john@example.com',
        password: 'password'
      },
      profile: {
        first_name: 'John',
        last_name: 'Doe',
        birth_date: '1990-01-01',
        description: 'Some description'
      }
    }

    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'error'
  end
end
