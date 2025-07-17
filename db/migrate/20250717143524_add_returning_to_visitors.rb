class AddReturningToVisitors < ActiveRecord::Migration[8.0]
  def change
    add_column :visitors, :returning, :boolean
  end
end
