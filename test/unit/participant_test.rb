require File.dirname(__FILE__) + '/../test_helper'

class ParticipantTest < Test::Unit::TestCase
  fixtures :participants

  def test_validates_email
    p = Participant.new(:name => "Sebastian",
                        :email => "skanthak at gmail dot com")
    assert !p.valid?
    assert p.errors.invalid?("email")
  end

  def test_accepts_valid_email
    p = Participant.new(:name => "Sebastian",
                        :email => "s.kanthak79-ultidate+r-skanthak=gmail.com@rathaus1178.muehlheim-online.de")
    assert p.valid?
  end

  def test_email_optional
    p = Participant.new(:name => "Sebastian",
                        :email => "")
    assert p.valid?
  end
end
