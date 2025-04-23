class CreateLanguages < ActiveRecord::Migration[8.0]
  def change
    create_table :languages do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :city_languages do |t|
      t.references :city, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end

    add_index :city_languages, [ :city_id, :language_id ], unique: true
  end
end

# english = Language.create!(name: "English", code: "en")
# german = Language.create!(name: "German", code: "de")
# spanish = Language.create!(name: "Spanish", code: "es")
# catalan = Language.create!(name: "Catalan", code: "ca")

# City.find_by(name: "Singapore").update!(languages: [ english ])
# City.find_by(name: "Barcelona").update!(languages: [ english, spanish, catalan ])
# City.find_by(name: "Munich").update!(languages: [ english, german ])
# City.find_by(name: "Berlin").update!(languages: [ english, german ])
# City.find_by(name: "Paderborn").update!(languages: [ english, german ])
