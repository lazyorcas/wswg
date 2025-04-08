class Init < ActiveRecord::Migration[8.0]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :time_zone, null: false

      t.timestamps
    end

    create_table :users do |t|
      t.belongs_to :city, null: false, foreign_key: true

      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.boolean :admin, default: false

      t.timestamps
    end

    create_table :accounts do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.string :provider, null: false
      t.string :uid, null: false
      t.jsonb :auth_hash, null: false

      t.timestamps
    end

    create_table :locations do |t|
      t.belongs_to :city, null: false, foreign_key: true

      t.string :full_address, null: false, index: { unique: true }
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end

    create_table :sources do |t|
      t.string :name, null: false
      t.string :homepage_url, null: false, index: { unique: true }
      t.string :icon_url, null: false

      t.string :city_url_finder_class_name, null: false
      t.string :city_events_finder_class_name, null: false

      t.timestamps
    end

    create_table :city_sources do |t|
      t.belongs_to :city, null: false, foreign_key: true
      t.belongs_to :source, foreign_key: true

      t.boolean :verified, index: true
      t.string :url, null: false

      t.string :icon_url
      t.string :city_events_finder_class_name

      t.timestamps
    end

    create_table :events do |t|
      t.belongs_to :city, null: false, foreign_key: true, index: true
      t.belongs_to :city_source, null: false, foreign_key: true

      t.string :uid, null: false
      t.string :url, null: false

      t.string :title, null: false
      t.string :description, null: false
      t.string :image_url, null: false

      t.string :start_date, null: false
      t.string :end_date, null: false
      t.string :start_time, null: false
      t.string :end_time, null: false
      t.integer :price, null: false

      t.belongs_to :location, foreign_key: true
      t.string :location_query

      t.timestamps
    end

    create_table :searches do |t|
      t.belongs_to :user, foreign_key: true, index: true

      t.string :public_id, null: false, index: { unique: true }

      t.string :query, null: false
      t.integer :status, null: false

      t.string :keywords
      t.jsonb :conditions

      t.jsonb :result

      t.timestamps
    end

    add_index :accounts, [ :provider, :uid ], unique: true
    add_index :city_sources, [ :city_id, :url ], unique: true
    add_index :events, [ :city_source_id, :uid ], unique: true
  end
end
