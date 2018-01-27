class CreateSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :specialties do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
