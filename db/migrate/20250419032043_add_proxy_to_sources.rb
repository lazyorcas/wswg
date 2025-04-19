class AddProxyToSources < ActiveRecord::Migration[8.0]
  def change
    add_column :sources, :proxy, :boolean, default: false
  end
end

# Source.where(name: "Eventbrite").update_all(proxy: true)
