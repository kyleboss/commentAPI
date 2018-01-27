class CreateDoctorsSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :doctors_specialties do |t|
      t.references :doctor, foreign_key: true
      t.references :specialty, foreign_key: true

      t.timestamps
    end
  end
end
