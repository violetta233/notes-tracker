class AddSourceNoteIdToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :source_note_id, :integer
  end
end
