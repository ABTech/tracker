require File.dirname(__FILE__) + '/../test_helper'
require 'attachments_controller_controller'

# Re-raise errors caught by the controller.
class AttachmentsControllerController; def rescue_action(e) raise e end; end

class AttachmentsControllerControllerTest < Test::Unit::TestCase
  def setup
    @controller = AttachmentsControllerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
