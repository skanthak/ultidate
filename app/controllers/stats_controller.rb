class StatsController < ApplicationController

  def highscore
    sql = "SELECT p.email, COUNT(e.id) AS event_count\n"
    sql << "FROM participants as p, events as e\n"
    sql << "WHERE p.event_id=e.id\n"
    sql << "AND p.email <> ''\n"
    sql << "AND e.is_public=1\n"
    sql << "AND e.date < now()\n"
    sql << "GROUP BY p.email\n"
    sql << "ORDER BY event_count DESC, p.email\n"
    sql << "LIMIT 100"

    @highscore = ActiveRecord::Base.connection.select_all(sql)
  end
end
