class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.belongs_to :message
      t.belongs_to :user
    end
  end
end
