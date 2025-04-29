class RemoveProxyAndNameAndUrlFromCitySources < ActiveRecord::Migration[8.0]
  def change
    remove_column :city_sources, :proxy
    remove_column :city_sources, :name
    remove_column :city_sources, :url
  end
end
