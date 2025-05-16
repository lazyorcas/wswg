class RenameAhoyVisitReferenceToVisitReferenceInAhoyEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :ahoy_events, :ahoy_visit_id, :visit_id
  end
end
