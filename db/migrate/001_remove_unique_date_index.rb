class RemoveUniqueDateIndex < ActiveRecord::Migration
  def self.up
    execute "DROP INDEX date ON events"
    add_index "events", "date", :unique => false
  end

  def self.down
    remove_index "events", "date"
    execute "CREATE UNIQUE INDEX date ON events (date)"
  end
end
