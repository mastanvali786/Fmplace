class CreateConversationMessages < ActiveRecord::Migration
  def change
    create_table :conversation_messages do |t|
      t.belongs_to :conversation
      t.belongs_to :message
    end
  end
end
