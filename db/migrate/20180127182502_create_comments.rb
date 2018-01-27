class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :doctor, foreign_key: true
      t.text :body, null: false
      t.integer :rating, null: false
      t.references :author, foreign_key: true
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
