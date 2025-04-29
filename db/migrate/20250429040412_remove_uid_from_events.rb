class RemoveUidFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :uid
  end
end
