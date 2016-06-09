class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|

     t.string :template
		t.text :content
    end
  end
end
