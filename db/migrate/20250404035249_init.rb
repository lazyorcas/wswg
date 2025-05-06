class Init < ActiveRecord::Migration[8.0]
  def change
    create_ahoy_visits
    create_ahoy_events

    create_cities
    create_languages
    create_city_languages
    create_locations
    create_location_queries

    create_sources
    create_city_sources
    create_events
    create_archived_links

    create_users
    create_accounts

    create_search_queries
    create_searches

    create_bookmarks
    create_seens
  end

  private

  def create_ahoy_visits
    create_table :ahoy_visits do |t|
      t.string :visit_token
      t.string :visitor_token

      # the rest are recommended but optional
      # simply remove any you don't want

      # user
      t.references :user

      # standard
      t.string :ip
      t.text :user_agent
      t.text :referrer
      t.string :referring_domain
      t.text :landing_page

      # technology
      t.string :browser
      t.string :os
      t.string :device_type

      # location
      t.string :country
      t.string :region
      t.string :city
      t.float :latitude
      t.float :longitude

      # utm parameters
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign

      # native apps
      t.string :app_version
      t.string :os_version
      t.string :platform

      t.datetime :started_at
    end

    add_index :ahoy_visits, :visit_token, unique: true
    add_index :ahoy_visits, [ :visitor_token, :started_at ]
  end

  def create_ahoy_events
    create_table :ahoy_events do |t|
      t.references :visit
      t.references :user

      t.string :name
      t.jsonb :properties
      t.datetime :time
    end

    add_index :ahoy_events, [ :name, :time ]
    add_index :ahoy_events, :properties, using: :gin, opclass: :jsonb_path_ops
  end

  def create_cities
    create_table :cities do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :slug, null: false, index: { unique: true }
      t.string :time_zone, null: false
      t.string :country_code, null: false
      t.string :currency, null: false
      t.float :lat, null: false
      t.float :lon, null: false

      t.timestamps
    end
  end

  def create_languages
    create_table :languages do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }

      t.timestamps
    end
  end

  def create_city_languages
    create_table :city_languages do |t|
      t.belongs_to :city, null: false, foreign_key: true
      t.belongs_to :language, null: false, foreign_key: true

      t.timestamps
    end

    add_index :city_languages, [ :city_id, :language_id ], unique: true
  end

  def create_locations
    create_table :locations do |t|
      t.string :full_address, null: false
      t.float :lat, null: false
      t.float :lon, null: false

      t.timestamps
    end
  end

  def create_location_queries
    create_table :location_queries do |t|
      t.belongs_to :location, foreign_key: true

      t.string :query, null: false, index: { unique: true }

      t.timestamps
    end
  end

  def create_sources
    create_table :sources do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :template_url, null: false
      t.string :scraper_type, null: false
      t.boolean :proxy, default: false

      t.timestamps
    end
  end

  def create_city_sources
    create_table :city_sources do |t|
      t.belongs_to :city, null: false, foreign_key: true, index: true
      t.belongs_to :source, null: false, foreign_key: true, index: true

      t.jsonb :url_params, default: {}
      t.datetime :last_fetched_at
      t.boolean :enabled, default: false

      t.timestamps
    end
  end

  def create_events
    create_table :events do |t|
      t.belongs_to :city_source, null: false, foreign_key: true, index: true
      t.belongs_to :location, foreign_key: true, index: true

      t.string :url, null: false, index: { unique: true }
      t.text :markdown
      t.string :title
      t.string :description
      t.string :tags
      t.string :image_url
      t.string :start_date
      t.string :end_date
      t.string :start_time
      t.string :end_time
      t.integer :price
      t.string :location_query

      t.timestamps
    end

    add_index :events, [ :location_id, :start_date, :end_date, :start_time, :end_time ]
  end

  def create_archived_links
    create_table :archived_links do |t|
      t.string :url, null: false, index: { unique: true }
      t.integer :reason, null: false
      t.jsonb :metadata, null: false

      t.timestamps
    end
  end

  def create_users
    create_table :users do |t|
      t.belongs_to :city, null: false, foreign_key: true

      t.string :email, null: false, index: { unique: true }
      t.boolean :admin, default: false

      t.timestamps
    end
  end

  def create_accounts
    create_table :accounts do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.string :provider, null: false
      t.string :uid, null: false
      t.jsonb :auth_hash, null: false

      t.timestamps
    end

    add_index :accounts, [ :provider, :uid ], unique: true
  end

  def create_search_queries
    create_table :search_queries do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: true

      t.string :query, null: false
      t.integer :status, null: false
      t.jsonb :result

      t.timestamps
    end
  end

  def create_searches
    create_table :searches do |t|
      t.belongs_to :search_query, null: false, foreign_key: true, index: true

      t.string :searchable_event_type, null: false
      t.integer :status, null: false
      t.string :keywords, null: false
      t.jsonb :conditions, null: false
      t.jsonb :result

      t.timestamps
    end
  end

  def create_bookmarks
    create_table :bookmarks do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :event, null: false, index: true, foreign_key: true

      t.boolean :removed, index: true
      t.datetime :removed_at, index: true

      t.timestamps
    end

    add_index :bookmarks, [ :user_id, :event_id ], unique: true
  end

  def create_seens
    create_table :seens do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :event, null: false, index: true, foreign_key: true

      t.timestamps
    end

    add_index :seens, [ :user_id, :event_id ], unique: true
  end
end
