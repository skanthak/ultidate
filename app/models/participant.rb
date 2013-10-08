class Participant < ActiveRecord::Base
  belongs_to :event
    
  validates_presence_of :name, :message => "muss vorhanden sein"
  validates_format_of :email, 
  :with =>  /^([^\@\s]+\@[a-z0-9\-\.]+)?$/i,
  :message => "ist ungültig"
  
end
