class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string  :name
      t.integer :country_id
      t.text	:comment
      t.string  :photo
      t.timestamps
    end
  end
end
