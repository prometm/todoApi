class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :position
      t.boolean :done
      t.datetime :deadline
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
