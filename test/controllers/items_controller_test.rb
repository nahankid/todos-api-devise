require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = create(:item)
    @headers = @item.todo.creator.create_new_auth_token

    @user = create(:user)
    @elses_headers = @user.create_new_auth_token
  end

  test "should get index for authorized user" do
    get todo_items_url(@item.todo), headers: @headers, as: :json
    assert_response :success
  end

  test "should not get index for unauthorized user" do
    get todo_items_url(@item.todo), as: :json
    assert_response :unauthorized
  end

  test "should create item for authorized user" do
    assert_difference('Item.count') do
      post todo_items_url(@item.todo), params: { item: { name: Faker::Name.name, done: false } }, headers: @headers, as: :json
    end

    assert_response :created
  end

  test "should not create item for unauthorized user" do
    assert_no_difference('Item.count') do
      post todo_items_url(@item.todo), params: { item: { name: Faker::Name.name, done: false } }, as: :json
    end

    assert_response :unauthorized
  end

  test "should show item to authorized user" do
    get todo_item_url(@item.todo, @item), headers: @headers, as: :json
    assert_response :success
  end

  test "should not show item to unauthorized user" do
    get todo_item_url(@item.todo, @item), as: :json
    assert_response :unauthorized
  end

  test "should update item for authorized user" do
    patch todo_item_url(@item.todo, @item), params: { item: { name: Faker::Name.name, done: false } }, headers: @headers, as: :json
    assert_response :success
  end

  test "should not update item for unauthorized user" do
    patch todo_item_url(@item.todo, @item), params: { item: { name: Faker::Name.name, done: false } }, as: :json
    assert_response :unauthorized
  end

  test "should not update item for non-owner" do
    patch todo_item_url(@item.todo, @item), params: { item: { name: Faker::Name.name, done: false } }, headers: @elses_headers, as: :json
    assert_response :not_found
  end

  test "should destroy item for authorized user" do
    assert_difference('Item.count', -1) do
      delete todo_item_url(@item.todo, @item), headers: @headers, as: :json
    end

    assert_response :no_content
  end

  test "should not destroy item for unauthorized user" do
    assert_no_difference('Item.count') do
      delete todo_item_url(@item.todo, @item), as: :json
    end

    assert_response :unauthorized
  end
end
