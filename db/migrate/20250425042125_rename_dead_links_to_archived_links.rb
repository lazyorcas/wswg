class RenameDeadLinksToArchivedLinks < ActiveRecord::Migration[8.0]
  def change
    rename_table :dead_links, :archived_links
    add_column :archived_links, :reason, :integer
    add_column :archived_links, :details, :jsonb
  end
end

# ArchivedLink.update_all(reason: :not_found_or_expired)
