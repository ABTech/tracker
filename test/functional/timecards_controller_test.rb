require File.dirname(__FILE__) + '/../test_helper'
require 'timecards_controller'

# Re-raise errors caught by the controller.
class TimecardsController; def rescue_action(e) raise e end; end

class TimecardsControllerTest < Test::Unit::TestCase
  def setup
    @controller = TimecardsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
