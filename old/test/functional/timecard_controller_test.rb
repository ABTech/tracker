require File.dirname(__FILE__) + '/../test_helper'
require 'timecard_controller'

# Re-raise errors caught by the controller.
class TimecardController; def rescue_action(e) raise e end; end

class TimecardControllerTest < Test::Unit::TestCase
  def setup
    @controller = TimecardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
