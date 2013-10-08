require File.dirname(__FILE__) + '/../test_helper'

require 'event_helper' 

class EventTest < Test::Unit::TestCase
  fixtures :events, :participants, :users

  def setup
    @event = Event.find(1)
  end

  # Replace this with your real tests.
  class Helper
    include EventHelper
  end
  
  def test_format_date_short
    h = Helper.new
    assert_equal "01.03.2005", h.format_date_short(Date.new(2005,03,01))
  end
  
  def test_events_from
    @events = Event.find_from(Date.civil(2005,04,15))
    assert @events.include?(@test_event)
    assert !@events.include?(@old_event)
    assert_equal 2, @events.first.participant_count.to_i
    assert_equal 0, @events.last.participant_count.to_i
  end

  def test_public_events_from
    events = Event.find_from(Date.civil(2005,04,15), :public => true)
    
    assert !events.include?(events(:test_event))
    assert events.include?(events(:birthday_event))
    
    assert_equal [true] * events.size, events.map{|e| e.is_public?}
  end

  def test_past_events
    events = Event.find_past_events(Date.civil(2005,4,15))

    assert events.include?(events(:old_event))
    assert_equal 1, events.size
  end

  def test_participants_destroyed
    assert Participant.find_all_by_event_id(@test_event.id).size > 0
    @test_event.destroy
    assert_equal 0, Participant.find_all_by_event_id(@test_event.id).size
  end

  def test_destroyable_by
    assert !@test_event.destroyable_by?(@bob)
    assert @test_event.destroyable_by?(@longbob)
  end

  def test_event_email_address
    assert_equal "3@ultidate.de", events(:birthday_event).email_address
  end

  def test_duration_accepts_number
    e = dummy_event
    e.duration = 2
    assert e.valid?
  end

  def test_duration_rejects_string
    e = dummy_event
    e.duration = "foo"
    assert !e.valid?
    assert e.errors.invalid?("duration")
  end

  def dummy_event
    Event.new(:year => 2006, :month => 05, :day => 21, :title => "Dummy")
  end

  def test_end_date
    e1 = events(:test_event)
    assert_equal e1.date, e1.end_date, "End date should be equal to start date for single day events"
    
    e2 = events(:talampaya)
    assert_equal Date.civil(2006,6,5), e2.end_date
  end
end
