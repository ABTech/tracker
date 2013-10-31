require 'test_helper'

class HeartbeatControllerTest < ActionController::TestCase
  test "it should always return 200" do
    get(:heartbeat)

    assert_response :ok
  end
end
