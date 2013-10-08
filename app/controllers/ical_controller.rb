class IcalController < ApplicationController
  def index
    events = Event.find_from(Date.today-30)

    cal_fields = []
    cal_fields << Vpim::DirectoryInfo::Field.create("X-WR-CALNAME", "Ultidate (Ars Ludendi)")
    cal_fields << Vpim::DirectoryInfo::Field.create("X-WR-Timezone", "Europe/Berlin")
    cal = Vpim::Icalendar.create cal_fields

    now = Time.now
    events.each do |e|
      cal.add_event do |ev|
        ev.dtstart e.date
        ev.dtend(e.date+e.duration)
        ev.summary encode_ical_text(e.title)
        ev.description encode_ical_text(e.description)
        ev.dtstamp now
        ev.url url_for(:controller => 'event', :action => 'show', :id => e.id)
        ev.uid "ultidate-#{e.id}@kanthak.net"
      end
    end
    
    render :text => encode_non_ascii(cal.encode), :content_type => "text/calendar; charset=ISO-8859-1"
  end

  private

  def encode_ical_text(val)
    val.gsub(/[,;\n\\\cM]/) do |c|
      case c
      when "\cM"
        ""
      when "\n"
        "\\n"
      else
        "\\#{c}"
      end
    end
  end

  NON_ASCII_MAP = { "ה" => "ae", "צ" => "oe", "ü" => "ue",
    "ß" => "ss", "ִ" => "Ae", "ײ" => "Oe", "Ü" => "Ue" }
    
  def encode_non_ascii(val)
    val.gsub(/[הצüßִײÜ]/) do |c|
      NON_ASCII_MAP[c]
    end
  end
end
