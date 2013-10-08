require File.dirname(__FILE__) + '/../test_helper'
require 'ical_controller'

# Re-raise errors caught by the controller.
class IcalController; def rescue_action(e) raise e end; end

class IcalControllerTest < Test::Unit::TestCase
  def setup
    @controller = IcalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_produces_ical
    get 'index'
    assert_response :success
    assert_match /^text\/calendar/, @response.headers["Content-Type"]
    assert_match /^BEGIN:VCALENDAR/, @response.body
  end
end
