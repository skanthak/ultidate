require File.dirname(__FILE__) + '/../test_helper'
require 'event_controller'

# Re-raise errors caught by the controller.
class EventController; def rescue_action(e) raise e end; end

class EventControllerTest < Test::Unit::TestCase
  fixtures :events, :users
  
  def setup
    @controller = EventController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user] = @bob
  end

  # Replace this with your real tests.
  def test_edit_event
    templates = { "display" => "_display_event",
                  "edit" => "_edit_event" }
    templates.each do |template,file|
        get("load_event", { "id" => @test_event.id.to_s, "template" => template })
        assert_template_has "event"
        assert_equal "Training", @response.template_objects["event"].title
        assert_rendered_file file, "Did not render file '#{file}' for param template='#{template}'"
    end
  end

  def test_by_date_with_unique_event
    get "by_date", { "year" => "2005", "month" => "1", "day" => 1 }
    assert_redirected_to :action => "show", :id => 2
  end

  def test_by_date_with_multiple_events
    get "by_date", { "year" => "2005", "month" => "6", "day" => "18" }
    
    assert_template "by_date"

    events = assigns(:events)
    assert_not_nil events
    assert_equal 2, events.size

    assert_not_nil assigns(:date)
    assert_equal Date.new(2005,6,18), assigns(:date)

    

  end

  def test_by_date_without_event
    get "by_date", { "year" => "2006", "month" => "3", "day" => "18" }

    assert_template "by_date"
    
    assert_equal 0, assigns(:events).size
  end

  def test_by_date_routing
    assert_routing "/2006/04/01", :controller => 'event', :action => 'by_date', :year => "2006", :month => "04", :day => "01"

    assert_routing "/2006/4/1", :controller => 'event', :action => 'by_date', :year => "2006", :month => "4", :day => "1"

  end

  def test_new_event_on_same_date
    get "new", { "year" => "2005", "month" => "1", "day" => "1"}
    
    assert_template "new"
  end

  def test_show
    get "show", :id => 1

    assert_template "show"
    assert_equal events(:test_event), assigns(:event)
  end

  def test_calendar_without_user
    @request.session[:user] = nil
    get 'calendar'

    assert_template 'calendar'

    assert_not_nil assigns(:events)
    assert_not_nil assigns(:past_events)
  end
end
