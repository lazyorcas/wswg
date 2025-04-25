class AddNonNullCheckToReasonInArchivedLinks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :archived_links, :reason, false
  end
end
