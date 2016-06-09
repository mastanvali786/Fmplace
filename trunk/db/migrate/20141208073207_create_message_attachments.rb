class CreateMessageAttachments < ActiveRecord::Migration
  def change
    create_table :message_attachments do |t|
      t.belongs_to :message, index: true
      t.string :attachment
    end
  end
end
