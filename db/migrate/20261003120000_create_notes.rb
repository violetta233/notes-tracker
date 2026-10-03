class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :tag
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
