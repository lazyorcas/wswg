class RemoveNotificationFrequencyFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :notification_frequency
  end
end
