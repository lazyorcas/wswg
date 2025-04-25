class AddLastFetchedAtToSources < ActiveRecord::Migration[8.0]
  def change
    add_column :sources, :last_fetched_at, :datetime
  end
end

# Source.where(proxy: true).update_all(last_fetched_at: 1.day.ago)
