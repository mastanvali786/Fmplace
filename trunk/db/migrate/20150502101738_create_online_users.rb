class CreateOnlineUsers < ActiveRecord::Migration
  def change
    create_table :online_users do |t|
      t.text :session_id
      t.string :user_type, default: "GUEST"
      t.integer :user_id, default: 0
      t.string :ip_address
      t.string :url
      t.string :browser_name
      t.string :browser_version
      t.string :platform
      t.timestamps
    end
  end
end
