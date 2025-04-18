class Init < ActiveRecord::Migration[8.0]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :time_zone, null: false
      t.string :currency, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end

    create_table :users do |t|
      t.belongs_to :city, null: false, foreign_key: true

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

      t.string :full_address, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end

    create_table :sources do |t|
      t.belongs_to :city, null: false, foreign_key: true

      t.string :name, null: false
      t.string :url, null: false, index: { unique: true }

      t.string :thing_type, null: false

      t.timestamps
    end

    create_table :events do |t|
      t.string :type

      t.belongs_to :city, null: false, foreign_key: true, index: true
      t.belongs_to :source, null: false, foreign_key: true

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

      t.belongs_to :location, foreign_key: true, index: true
      t.string :location_query, index: true

      t.timestamps
    end

    create_table :searches do |t|
      t.belongs_to :user, foreign_key: true, index: true

      t.string :model_type, null: false
      t.string :query, null: false
      t.integer :status, null: false

      t.string :keywords
      t.jsonb :conditions

      t.jsonb :result

      t.timestamps
    end

    create_table :bookmarks do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :bookmarkable, polymorphic: true, null: false, index: true

      t.boolean :removed, index: true
      t.datetime :removed_at, index: true

      t.timestamps
    end

    create_table :seens do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :seenable, polymorphic: true, null: false, index: true

      t.timestamps
    end

    add_index :accounts, [ :provider, :uid ], unique: true
    add_index :events, [ :source_id, :uid ], unique: true
    add_index :bookmarks, [ :user_id, :bookmarkable_id, :bookmarkable_type ], unique: true
    add_index :seens, [ :user_id, :seenable_id, :seenable_type ], unique: true
  end
end
