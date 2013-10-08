class RemoveShirts < ActiveRecord::Migration
  def self.up
    drop_table :shirts
  end

  def self.down
    create_table "shirts", :force => true do |t|
      t.column "name", :string, :limit => 80
      t.column "size", :string, :limit => 4
      t.column "gender", :string, :limit => 1
      t.column "arms", :integer, :limit => 4
      t.column "shirt_name", :string, :limit => 40
      t.column "shirt_number", :string, :limit => 4
      t.column "comment", :text
    end
  end
end
