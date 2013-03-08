class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name, :limit => 8
      t.string  :password, :limit => 64
      t.string  :salt, :limit => 64
      t.string  :email, :limit => 32
      t.integer :score, :default => 100

      t.timestamps
    end
  end
end
