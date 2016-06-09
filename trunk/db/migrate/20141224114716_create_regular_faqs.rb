class CreateRegularFaqs < ActiveRecord::Migration
  def change
    create_table :regular_faqs do |t|
      t.integer :role
      t.text :question
      t.text :answer
      t.string :topic
      t.timestamps
    end
  end
end
