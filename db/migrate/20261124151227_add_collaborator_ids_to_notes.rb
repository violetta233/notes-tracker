class AddCollaboratorIdsToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :collaborator_ids, :text
  end
end
