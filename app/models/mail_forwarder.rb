require 'net/smtp'

class MailForwarder
  def self.forward_mail(src)
    id = nil
    while (not id) and (line = src.gets())
      if line =~ /^X-Original-To: (\d+)@/
        id = $1
      end
    end
    fail "Could not determine ultidate event" unless id
    event = Event.find(id)
    rcpts = event.participants.map{|p| p.email}.select{|m| m and !m.empty?}
    Net::SMTP.start(SMTP_HOST) do |smtp|
      smtp.send_message(src, SMTP_FROM, rcpts)
    end
  end
  
  private 
  
  def self.fail(msg, errcode=100)
    print msg
    exit errcode
  end
end
