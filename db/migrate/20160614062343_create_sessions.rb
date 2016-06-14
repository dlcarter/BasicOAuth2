class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :token
      t.string :refresh_token
      t.string :user_id
      t.datetime :expires_at
    end
    add_index :sessions, :user_id
  end
end
