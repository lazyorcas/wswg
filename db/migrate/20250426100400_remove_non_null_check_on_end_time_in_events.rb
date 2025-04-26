class RemoveNonNullCheckOnEndTimeInEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_null :events, :end_time, true
  end
end
