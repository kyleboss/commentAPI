class CreateDoctors < ActiveRecord::Migration[5.2]
  def change
    create_table :doctors do |t|
      t.references :group, foreign_key: true
      t.string :name, null: false
      t.string :street_address, null: false
      t.string :zip_code, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.decimal :latitude, null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6

      t.timestamps
    end
  end
end
