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

ActiveRecord::Schema[8.0].define(version: 2025_04_04_035249) do
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

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "time_zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_cities_on_slug", unique: true
  end

  create_table "city_sources", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "source_id"
    t.boolean "verified"
    t.string "url", null: false
    t.string "icon_url"
    t.string "city_events_finder_class_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "url"], name: "index_city_sources_on_city_id_and_url", unique: true
    t.index ["city_id"], name: "index_city_sources_on_city_id"
    t.index ["source_id"], name: "index_city_sources_on_source_id"
    t.index ["verified"], name: "index_city_sources_on_verified"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "city_source_id", null: false
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
    t.index ["city_source_id", "uid"], name: "index_events_on_city_source_id_and_uid", unique: true
    t.index ["city_source_id"], name: "index_events_on_city_source_id"
    t.index ["location_id"], name: "index_events_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.string "full_address", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_locations_on_city_id"
    t.index ["full_address"], name: "index_locations_on_full_address", unique: true
  end

  create_table "searches", force: :cascade do |t|
    t.bigint "user_id"
    t.string "public_id", null: false
    t.string "query", null: false
    t.integer "status", null: false
    t.string "keywords"
    t.jsonb "conditions"
    t.jsonb "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_id"], name: "index_searches_on_public_id", unique: true
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name", null: false
    t.string "homepage_url", null: false
    t.string "icon_url", null: false
    t.string "city_url_finder_class_name", null: false
    t.string "city_events_finder_class_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["homepage_url"], name: "index_sources_on_homepage_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "city_sources", "cities"
  add_foreign_key "city_sources", "sources"
  add_foreign_key "events", "cities"
  add_foreign_key "events", "city_sources"
  add_foreign_key "events", "locations"
  add_foreign_key "locations", "cities"
  add_foreign_key "searches", "users"
  add_foreign_key "users", "cities"
end
