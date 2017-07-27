require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo = create(:todo)
    @headers = @todo.creator.create_new_auth_token
  end

  test "should get index for authenticated user" do
    get todos_url, headers: @headers, as: :json
    assert_response :success
  end

  test "should not get index for unautheticated user" do
    get todos_url, as: :json
    assert_response :unauthorized
  end

  test "should create todo" do
    assert_difference('Todo.count') do
      post todos_url, params: { todo: { title: Faker::Lorem.sentence } }, headers: @headers, as: :json
    end

    assert_response :created
  end

  test "should show todo to authorized user" do
    get todo_url(@todo), headers: @headers, as: :json
    assert_response :success
  end

  test "should not show todo to unauthorized user" do
    get todo_url(@todo), as: :json
    assert_response :unauthorized
  end

  test "should update todo for authorized user" do
    patch todo_url(@todo), params: { todo: { title: Faker::Lorem.sentence } }, headers: @headers, as: :json
    assert_response :success
  end

  test "should not update todo for unauthorized user" do
    patch todo_url(@todo), params: { todo: { title: Faker::Lorem.sentence } }, as: :json
    assert_response :unauthorized
  end

  test "should destroy todo for authorized user" do
    assert_difference('Todo.count', -1) do
      delete todo_url(@todo), headers: @headers, as: :json
    end

    assert_response :no_content
  end

  test "should not destroy todo for unauthorized user" do
    assert_no_difference('Todo.count', -1) do
      delete todo_url(@todo), as: :json
    end

    assert_response :unauthorized
  end
end
