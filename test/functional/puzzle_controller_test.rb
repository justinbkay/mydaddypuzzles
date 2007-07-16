require File.dirname(__FILE__) + '/../test_helper'
require 'puzzle_controller'

# Re-raise errors caught by the controller.
class PuzzleController; def rescue_action(e) raise e end; end

class PuzzleControllerTest < Test::Unit::TestCase
  def setup
    @controller = PuzzleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
