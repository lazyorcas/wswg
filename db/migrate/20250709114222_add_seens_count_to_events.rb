class AddSeensCountToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :seens_count, :integer, default: 0
  end
end

# Event.where.associated(:seens).each do |event|
#   event.update(seens_count: event.seens.count)
# end
