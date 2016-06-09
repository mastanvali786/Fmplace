class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :from
      t.integer :to
      t.string :subject
      t.boolean :read, default: false
      t.text :body
      t.integer :created_by
      t.integer :sender_message_id
      t.string :folder, default: 'sent'
      t.date :sent_at
      t.string :type, default: "Project"
      t.timestamps
    end
  end
end
