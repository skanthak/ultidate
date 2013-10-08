module EventHelper
      DAYS = %w( Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag )
      SHORT_DAYS = %w( So Mo Di Mi Do Fr Sa So )
      
      MONTHS = %w( Januar Februar März April Mai Juni Juli August September Oktober November Dezember )
     def format_date(date)
         "#{DAYS[date.wday]}, den #{date.day}. #{MONTHS[date.mon-1]} #{date.year}"
     end
     
     def format_date_short(date)
         format("%02d\.%02d\.%04d", date.day, date.month, date.year)
     end

     def event_date_short(event)
       if event.duration == 1
         format_date_short(event.date)
       else
         "#{format_date_short(event.date)}-#{format_date_short(event.end_date)}"
       end
     end

     def month_start(date)
        date - (date.day-1)
     end
     
     def month_end(date)
        (month_start(date) >> 1) - 1
     end

     def date_hash(date)
       {"year" => date.year, "month" => date.month, "day" => date.day }
     end

     def event_cal_title(events)
       if events.size == 1
         events.first.title
       else
         "#{events.first.title}, ..."
       end
     end

     def bool_helper(value)
       if value 
         "Ja"
       else
         "Nein"
       end
     end
end
