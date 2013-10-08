class EventController < ApplicationController
  helper :event
  
  before_filter :login_required, :except => ['calendar']
  
  def list
    @today = Date.today
    @events = Event.find_from(@today)
    @event_dates = @events.inject({}) do |m,e| 
      m[e.date] ||= []
      m[e.date] << e
      m
    end
  end

  def calendar
    today = Date.today
    @events = Event.find_from(today, :public => true)
    @past_events = Event.find_past_events(today, :public => true)
  end

  def load_event
    @event = Event.find(@params["id"])
    raise "Event does not exist" if @event.nil?
    case @params["template"]
    when "display" then render_partial "display_event"
    when "edit" then render_partial "edit_event"
    end
  end
  
  def update_event
    @event = Event.update(@params["id"], @params["event"])
    if @event.valid?
      render_partial "display_event"
    else
      render_partial "edit_event"
    end
  end
  
  def by_date
    @date = parse_date
    @events = Event.find_all_by_date(@date)
    case @events.size
    when 1
      redirect_to :action => 'show', :id => @events.first.id
    end
  end
  
  def show
    @event = Event.find(params[:id])
    redirect_to( { :action => 'new' }.update(date_hash(date)) ) if @event.nil?
    @participant = Participant.new do |p|
      p.name = cookies["ultidate_name"] if cookies["ultidate_name"]
    end
  end
  
  def new
    date = parse_date
    @event = Event.new do |e|
      e.date = date
      e.title = "Training"
    end
  end
  
  def create
    @event = Event.new(@params["event"])
#    @event.date = parse_date
    if @event.save
      flash["notice"] = "Termin wurde erstellt."
      redirect_to :action => 'show', :id => @event.id
    else
      render_action "new"
    end
  end
  
  def add_participant
    @participant = Participant.new(@params["participant"])
    @event = @participant.event
    if @participant.save
      cookies["ultidate_name"] = { :value => @participant.name, :expires => Time.now + 60*24*30 }
      flash["notice"] = "Neuer Teilnehmer wurde hinzugefügt."
      redirect_to :action => 'show', :id => @event.id
    else
      render_action "show"
    end
  end
  
  def load_participant
    @participant = Participant.find(@params["id"])
    case @params["template"]
    when "show" then render_participant "show_participant"
    when "edit" then render_participant "edit_participant"
    end
  end
  
  def update_participant
    @participant = Participant.update(@params["id"],@params["participant"])
    if @participant.valid?
      render_participant "show_participant"
    else
      render_participant"edit_participant"
    end
  end
  
  def destroy_participant
    p = Participant.find(@params["id"])
    event = p.event
    p.destroy
    flash["notice"] = "Teilnehmer #{p.name} entfernt."
    redirect_to :action => 'show', :id => event.id
  end
  
  def destroy
    @event = Event.find(@params["id"])
    raise "Permission denied" unless @event.destroyable_by?(@session[:user])
    @event.destroy
    flash["notice"] = "Termin '#{@event.title}' wurde mitsamt aller Teilnehmer gelöscht."
    redirect_to :action => "list"
  end

  private
  
  def parse_date
    Date.new(@params["year"].to_i,@params["month"].to_i,@params["day"].to_i)
  end
  
  def date_hash(date)
    { :year => date.year, :month => date.month, :day => date.day }
  end   
  
  def render_participant(template)
    render_partial template, :person => @participant, :htmlid => "participant-#{@participant.id}"
  end
  
end
