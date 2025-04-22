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

ActiveRecord::Schema[8.0].define(version: 2025_04_22_021418) do
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
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "bookmarkable_type", null: false
    t.bigint "bookmarkable_id", null: false
    t.boolean "removed"
    t.datetime "removed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bookmarkable_type", "bookmarkable_id"], name: "index_bookmarks_on_bookmarkable"
    t.index ["removed"], name: "index_bookmarks_on_removed"
    t.index ["removed_at"], name: "index_bookmarks_on_removed_at"
    t.index ["user_id", "bookmarkable_id", "bookmarkable_type"], name: "idx_on_user_id_bookmarkable_id_bookmarkable_type_0feb0fe0be", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "time_zone", null: false
    t.string "currency", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alias"
    t.index ["slug"], name: "index_cities_on_slug", unique: true
  end

  create_table "dead_links", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_dead_links_on_url", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "type"
    t.bigint "city_id", null: false
    t.bigint "source_id", null: false
    t.string "uid", null: false
    t.string "url", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "image_url", null: false
    t.string "start_date", null: false
    t.string "end_date", null: false
    t.string "start_time", null: false
    t.string "end_time", null: false
    t.integer "price", null: false
    t.bigint "location_id"
    t.string "location_query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_events_on_city_id"
    t.index ["location_id"], name: "index_events_on_location_id"
    t.index ["location_query"], name: "index_events_on_location_query"
    t.index ["source_id", "uid"], name: "index_events_on_source_id_and_uid", unique: true
    t.index ["source_id"], name: "index_events_on_source_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.string "full_address", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_locations_on_city_id"
  end

  create_table "searches", force: :cascade do |t|
    t.bigint "user_id"
    t.string "model_type", null: false
    t.string "query", null: false
    t.integer "status", null: false
    t.string "keywords"
    t.jsonb "conditions"
    t.jsonb "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "seens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "seenable_type", null: false
    t.bigint "seenable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seenable_type", "seenable_id"], name: "index_seens_on_seenable"
    t.index ["user_id", "seenable_id", "seenable_type"], name: "index_seens_on_user_id_and_seenable_id_and_seenable_type", unique: true
    t.index ["user_id"], name: "index_seens_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.string "thing_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "proxy", default: false
    t.index ["city_id"], name: "index_sources_on_city_id"
    t.index ["url"], name: "index_sources_on_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.string "email", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "events", "cities"
  add_foreign_key "events", "locations"
  add_foreign_key "events", "sources"
  add_foreign_key "locations", "cities"
  add_foreign_key "searches", "users"
  add_foreign_key "seens", "users"
  add_foreign_key "sources", "cities"
  add_foreign_key "users", "cities"
end
