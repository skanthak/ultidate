require File.dirname(__FILE__) + '/../test_helper'
require 'stats_controller'

# Re-raise errors caught by the controller.
class StatsController; def rescue_action(e) raise e end; end

class StatsControllerTest < Test::Unit::TestCase
  fixtures :events, :users, :participants
  
  def setup
    @controller = StatsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_highscore
    get 'highscore'
    assert_not_nil assigns(:highscore)

    highscore = assigns(:highscore)
    assert_equal 1, highscore.length

    assert_equal "nummer1@domain.com", highscore[0]['email']
    assert_equal "1", highscore[0]['event_count']
  end
end
