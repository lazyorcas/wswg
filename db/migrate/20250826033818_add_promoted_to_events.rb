class AddPromotedToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :promoted, :boolean
  end
end
