class AddNotificationFrequencyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :notification_frequency, :integer
  end
end
