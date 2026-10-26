class CreateHabits < ActiveRecord::Migration[8.1]
  def change
    create_table :habits do |t|
      t.string :name, null: false
      t.string :frequency
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
