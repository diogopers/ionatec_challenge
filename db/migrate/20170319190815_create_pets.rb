class CreatePets < ActiveRecord::Migration[5.0]
  def change
    create_table :pets do |t|
      t.string :breed
      t.string :gender
      t.boolean :castrated
      t.date :birth_date
      t.string :name
      t.date :last_visit
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
