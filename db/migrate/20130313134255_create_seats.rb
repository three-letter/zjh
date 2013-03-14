class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :seat_id
      t.integer :room_id
      t.integer :user_id
      t.integer :state, :default => 0
      t.integer :score, :default => 0
      t.string  :poker

      t.timestamps
    end
  end
end
