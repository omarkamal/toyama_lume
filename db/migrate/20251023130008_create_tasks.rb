class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :category
      t.string :priority
      t.boolean :is_global, default: false
      t.integer :usage_count, default: 0

      t.timestamps
    end
  end
end
