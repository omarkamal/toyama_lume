class CreateWorkZones < ActiveRecord::Migration[7.0]
  def change
    create_table :work_zones do |t|
      t.string :name, null: false
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.integer :radius, null: false # in meters
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :work_zones, :active
  end
end
