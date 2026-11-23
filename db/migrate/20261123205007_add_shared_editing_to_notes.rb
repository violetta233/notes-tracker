class AddSharedEditingToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :shared_editing, :boolean
  end
end
