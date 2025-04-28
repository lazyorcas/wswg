class CreateTimeZones < ActiveRecord::Migration[8.0]
  def change
    create_table :time_zones do |t|
      t.string :name, index: { unique: true }
      t.timestamps
    end
  end
end

# TimeZone.create(name: "Asia/Singapore")
# TimeZone.create(name: "Europe/Berlin")
