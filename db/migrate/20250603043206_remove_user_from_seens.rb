class RemoveUserFromSeens < ActiveRecord::Migration[8.0]
  def change
    remove_reference :seens, :user, foreign_key: true
  end
end
