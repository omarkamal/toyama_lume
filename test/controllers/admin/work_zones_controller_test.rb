require "test_helper"

class Admin::WorkZonesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_work_zones_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_work_zones_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_work_zones_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_work_zones_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_work_zones_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_work_zones_destroy_url
    assert_response :success
  end
end
