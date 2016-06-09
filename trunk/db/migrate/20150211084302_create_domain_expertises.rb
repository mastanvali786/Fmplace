class CreateDomainExpertises < ActiveRecord::Migration
  def change
    create_table :domain_expertises do |t|
      t.integer	:user_id
      t.string	:title
      t.text	:range
      t.text	:description
      t.timestamps
    end
  end
end
