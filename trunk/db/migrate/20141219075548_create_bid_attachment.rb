class CreateBidAttachment < ActiveRecord::Migration
  def change
    create_table :bid_attachments do |t|
      t.string :attachment
      t.belongs_to :bid
      t.string :file_name
      t.string :content_type
      t.integer :file_size
    end
  end
end
