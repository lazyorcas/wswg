class AddAliasToCities < ActiveRecord::Migration[8.0]
  def change
    add_column :cities, :alias, :string
  end
end

# City.find_by(name: "Munich").update(alias: "München")
