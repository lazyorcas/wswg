class AddCountryCodeToCities < ActiveRecord::Migration[8.0]
  def change
    add_column :cities, :country_code, :string
  end
end
