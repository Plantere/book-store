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

ActiveRecord::Schema[7.1].define(version: 2024_01_12_173226) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "pgsodium"
  create_schema "pgsodium_masks"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_graphql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "pgjwt"
  enable_extension "pgsodium"
  enable_extension "plpgsql"
  enable_extension "supabase_vault"
  enable_extension "uuid-ossp"

  create_table "addresses", force: :cascade do |t|
    t.bigint "users_id"
    t.string "name"
    t.string "country"
    t.string "state"
    t.string "district"
    t.string "number"
    t.string "complement"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_id"], name: "index_addresses_on_users_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "full_name"
    t.date "birth_date"
    t.text "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_name", "birth_date"], name: "index_authors_on_full_name_and_birth_date", unique: true
  end

  create_table "book_images", force: :cascade do |t|
    t.bigint "books_id"
    t.string "image_type"
    t.string "image_path"
    t.string "alt_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["books_id"], name: "index_book_images_on_books_id"
  end

  create_table "books", force: :cascade do |t|
    t.bigint "authors_id"
    t.bigint "publishers_id"
    t.string "name"
    t.text "description"
    t.integer "stock_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "genres_id"
    t.index ["authors_id"], name: "index_books_on_authors_id"
    t.index ["genres_id"], name: "index_books_on_genres_id"
    t.index ["name"], name: "index_books_on_name"
    t.index ["publishers_id"], name: "index_books_on_publishers_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "order_details", force: :cascade do |t|
    t.bigint "orders_id"
    t.bigint "books_id"
    t.integer "quantity"
    t.decimal "price", precision: 16, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["books_id"], name: "index_order_details_on_books_id"
    t.index ["orders_id"], name: "index_order_details_on_orders_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "addresses_id"
    t.decimal "price", precision: 16, scale: 2
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addresses_id"], name: "index_orders_on_addresses_id"
    t.index ["users_id"], name: "index_orders_on_users_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "users_id"
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.string "avatar"
    t.text "descritpion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_id"], name: "index_profiles_on_users_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true
  end

  create_table "telephones", force: :cascade do |t|
    t.bigint "users_id"
    t.string "phone_number"
    t.string "area_code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_id"], name: "index_telephones_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "email"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
