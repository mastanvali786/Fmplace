class CreateContactEmails < ActiveRecord::Migration
  def change
    create_table :contact_emails do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :message
      t.boolean :email_copy

      t.timestamps
    end
  end
end
