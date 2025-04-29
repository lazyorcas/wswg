class RemoveSeenableFromSeens < ActiveRecord::Migration[8.0]
  def change
    remove_reference :seens, :seenable, null: true, polymorphic: true
  end
end
