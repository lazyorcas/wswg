# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_11_151044) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.jsonb "auth_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_accounts_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.string "time_zone"
    t.integer "duration", default: 0
    t.datetime "duration_synced_at"
    t.string "referrer_host"
    t.boolean "analyzable"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "archived_links", force: :cascade do |t|
    t.string "url", null: false
    t.integer "reason", null: false
    t.jsonb "metadata", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_archived_links_on_url", unique: true
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.boolean "removed"
    t.datetime "removed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bookmarkable_type", null: false
    t.bigint "bookmarkable_id", null: false
    t.index ["bookmarkable_type", "bookmarkable_id", "event_id"], name: "idx_on_bookmarkable_type_bookmarkable_id_event_id_de6daff0b6", unique: true
    t.index ["bookmarkable_type", "bookmarkable_id"], name: "index_bookmarks_on_bookmarkable"
    t.index ["event_id"], name: "index_bookmarks_on_event_id"
    t.index ["removed"], name: "index_bookmarks_on_removed"
    t.index ["removed_at"], name: "index_bookmarks_on_removed_at"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "time_zone", null: false
    t.string "country_code", null: false
    t.string "currency", null: false
    t.float "lat", null: false
    t.float "lon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cities_on_name", unique: true
    t.index ["slug"], name: "index_cities_on_slug", unique: true
  end

  create_table "city_languages", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "language_id"], name: "index_city_languages_on_city_id_and_language_id", unique: true
    t.index ["city_id"], name: "index_city_languages_on_city_id"
    t.index ["language_id"], name: "index_city_languages_on_language_id"
  end

  create_table "city_sources", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "source_id", null: false
    t.jsonb "url_params", default: {}
    t.datetime "last_fetched_at"
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "source_id"], name: "index_city_sources_on_city_id_and_source_id", unique: true
    t.index ["city_id"], name: "index_city_sources_on_city_id"
    t.index ["source_id"], name: "index_city_sources_on_source_id"
  end

  create_table "credit_transactions", force: :cascade do |t|
    t.integer "transaction_type", null: false
    t.integer "amount", null: false
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "creditable_type", null: false
    t.bigint "creditable_id", null: false
    t.index ["creditable_type", "creditable_id", "transaction_type", "expires_at"], name: "idx_on_creditable_type_creditable_id_transaction_ty_d26d242ca4"
    t.index ["creditable_type", "creditable_id"], name: "index_credit_transactions_on_creditable"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "city_source_id", null: false
    t.bigint "location_id"
    t.string "url", null: false
    t.text "markdown"
    t.string "title"
    t.string "description"
    t.string "tags"
    t.string "image_url"
    t.string "start_date"
    t.string "end_date"
    t.string "start_time"
    t.string "end_time"
    t.integer "price"
    t.string "location_query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seens_count", default: 0
    t.integer "attendees_count"
    t.datetime "attendees_count_finalized_at"
    t.string "organizer_url"
    t.index ["city_source_id"], name: "index_events_on_city_source_id"
    t.index ["location_id", "start_date", "end_date", "start_time", "end_time"], name: "idx_on_location_id_start_date_end_date_start_time_e_415cb0e2f4"
    t.index ["location_id"], name: "index_events_on_location_id"
    t.index ["url"], name: "index_events_on_url", unique: true
  end

  create_table "field_test_memberships", force: :cascade do |t|
    t.string "participant_type"
    t.string "participant_id"
    t.string "experiment"
    t.string "variant"
    t.datetime "created_at"
    t.boolean "converted", default: false
    t.index ["experiment", "created_at"], name: "index_field_test_memberships_on_experiment_and_created_at"
    t.index ["participant_type", "participant_id", "experiment"], name: "index_field_test_memberships_on_participant", unique: true
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_languages_on_code", unique: true
  end

  create_table "location_queries", force: :cascade do |t|
    t.bigint "location_id"
    t.string "query", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_location_queries_on_location_id"
    t.index ["query"], name: "index_location_queries_on_query", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "full_address", null: false
    t.float "lat", null: false
    t.float "lon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lat", "lon"], name: "index_locations_on_lat_and_lon"
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.string "authenticatable_type"
    t.integer "authenticatable_id"
    t.datetime "timeout_at", precision: nil, null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "claimed_at", precision: nil
    t.string "token_digest", null: false
    t.string "identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
    t.index ["identifier"], name: "index_passwordless_sessions_on_identifier", unique: true
  end

  create_table "search_queries", force: :cascade do |t|
    t.string "query", null: false
    t.integer "status", null: false
    t.jsonb "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "searcher_type"
    t.bigint "searcher_id"
    t.bigint "city_id", null: false
    t.index ["city_id"], name: "index_search_queries_on_city_id"
    t.index ["searcher_type", "searcher_id"], name: "index_search_queries_on_searcher"
  end

  create_table "searches", force: :cascade do |t|
    t.bigint "search_query_id", null: false
    t.string "searchable_event_type", null: false
    t.integer "status", null: false
    t.string "keywords", null: false
    t.jsonb "conditions", null: false
    t.jsonb "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["search_query_id"], name: "index_searches_on_search_query_id"
  end

  create_table "seens", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "seenable_type"
    t.bigint "seenable_id"
    t.index ["event_id"], name: "index_seens_on_event_id"
    t.index ["seenable_type", "seenable_id", "event_id"], name: "index_seens_on_seenable_type_and_seenable_id_and_event_id", unique: true
    t.index ["seenable_type", "seenable_id"], name: "index_seens_on_seenable"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true
    t.index ["target_type", "target_id"], name: "index_settings_on_target_type_and_target_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name", null: false
    t.string "template_url", null: false
    t.string "scraper_type", null: false
    t.boolean "proxy", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sources_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.bigint "city_id"
    t.string "email", null: false
    t.boolean "admin", default: false
    t.integer "credits", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.bigint "city_id"
    t.string "visitor_token", null: false
    t.integer "credits", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_visitors_on_city_id"
    t.index ["visitor_token"], name: "index_visitors_on_visitor_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "ahoy_visits", "visitors", column: "visitor_token", primary_key: "visitor_token"
  add_foreign_key "bookmarks", "events"
  add_foreign_key "city_languages", "cities"
  add_foreign_key "city_languages", "languages"
  add_foreign_key "city_sources", "cities"
  add_foreign_key "city_sources", "sources"
  add_foreign_key "events", "city_sources"
  add_foreign_key "events", "locations"
  add_foreign_key "location_queries", "locations"
  add_foreign_key "search_queries", "cities"
  add_foreign_key "searches", "search_queries"
  add_foreign_key "seens", "events"
  add_foreign_key "users", "cities"
  add_foreign_key "visitors", "cities"
end
