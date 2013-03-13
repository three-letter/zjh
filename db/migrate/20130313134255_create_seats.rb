class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats, :id => false do |t|
      t.integer :seat_id
      t.integer :room_id
      t.integer :user_id
      t.integer :state
      t.integer :score
      t.string :poker

      t.timestamps
    end
  end
end
