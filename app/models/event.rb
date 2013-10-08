class Event < ActiveRecord::Base
  has_many :participants, :dependent => true
  
  attr_accessible :date, :title, :description, :is_public, :duration
  
  validates_presence_of :title, :message => "muss vorhanden sein"
  validates_inclusion_of :duration, :in => 1..30, :message => "muss 1-30 Tage betragen"

  # Find all events scheduled at or after a certain day (defaults to today)
  def self.find_from(date=Date.today, options={})
    cond_sql = "events.date >= ?"
    cond_sql << " AND events.is_public" if options[:public]
    self.find_all_with_count(:conditions => [cond_sql, date],
                             :order => "events.date ASC")
  end
  
  def self.find_past_events(date=Date.today, options={})
    days = options[:days] || 180
    from = date - days

    cond_sql = "events.date >= ? AND events.date < ?"
    cond_sql << " AND events.is_public" if options[:public]
    self.find_all_with_count(:conditions => [cond_sql, from,date],
                             :order => "events.date DESC")
  end
  
  def self.find_all_with_count(options={})
    find_options = {
      :joins => "LEFT JOIN participants ON events.id=participants.event_id",
      :select => "events.*, COUNT(participants.id) AS participant_count",
      :group => "events.id" }
    find_options.update(options)
    
    self.find(:all, find_options)
    
  end
  
  def email_address
    "#{self.id}@ultidate.de"
  end
  
  def end_date
    self.date + (self.duration - 1)
  end

  def destroyable_by?(user)
    user != nil and user.is_admin?
  end
  
end
