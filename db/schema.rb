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

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_cities_on_slug", unique: true
  end

  create_table "city_sources", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "source_id"
    t.boolean "verified"
    t.string "url", null: false
    t.string "city_events_finder_class_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "url"], name: "index_city_sources_on_city_id_and_url", unique: true
    t.index ["city_id"], name: "index_city_sources_on_city_id"
    t.index ["source_id"], name: "index_city_sources_on_source_id"
    t.index ["verified"], name: "index_city_sources_on_verified"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "city_source_id", null: false
    t.string "uid", null: false
    t.string "url", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "start_date", null: false
    t.string "end_date", null: false
    t.string "start_time", null: false
    t.string "end_time", null: false
    t.integer "price", null: false
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_source_id", "uid"], name: "index_events_on_city_source_id_and_uid", unique: true
    t.index ["city_source_id"], name: "index_events_on_city_source_id"
  end

  create_table "searches", force: :cascade do |t|
    t.string "public_id", null: false
    t.string "query", null: false
    t.integer "status", null: false
    t.string "keywords"
    t.jsonb "conditions"
    t.jsonb "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_id"], name: "index_searches_on_public_id", unique: true
    t.index ["status"], name: "index_searches_on_status"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name", null: false
    t.string "homepage_url", null: false
    t.string "city_url_finder_class_name", null: false
    t.string "city_events_finder_class_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["homepage_url"], name: "index_sources_on_homepage_url", unique: true
  end

  add_foreign_key "city_sources", "cities"
  add_foreign_key "city_sources", "sources"
  add_foreign_key "events", "city_sources"
end
