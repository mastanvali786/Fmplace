class CreateProjectTimeFrames < ActiveRecord::Migration
  def change
    create_table :project_time_frames do |t|
      t.string :name

      t.timestamps
    end
  end
end
