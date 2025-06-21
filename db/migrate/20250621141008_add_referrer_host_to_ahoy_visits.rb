class AddReferrerHostToAhoyVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :ahoy_visits, :referrer_host, :string
  end
end
