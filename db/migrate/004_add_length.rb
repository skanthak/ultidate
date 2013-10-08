class AddLength < ActiveRecord::Migration
  def self.up
    add_column :events, :duration, :integer, :default => 1
  end

  def self.down
    remove_column :events, :duration
  end
end
