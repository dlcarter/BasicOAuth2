class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password
      t.integer :client_id
    end
    add_index :users, :client_id
  end
end
