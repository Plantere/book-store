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

ActiveRecord::Schema[7.1].define(version: 2024_01_12_124757) do
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

  create_table "authors", id: false, force: :cascade do |t|
    t.string "id"
    t.string "full_name"
    t.date "birth_date"
    t.text "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_name", "birth_date"], name: "index_authors_on_full_name_and_birth_date", unique: true
  end

  create_table "books", id: false, force: :cascade do |t|
    t.string "id"
    t.string "authors_id"
    t.string "publishers_id"
    t.string "name"
    t.text "description"
    t.integer "stock_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authors_id"], name: "index_books_on_authors_id"
    t.index ["name"], name: "index_books_on_name"
    t.index ["publishers_id"], name: "index_books_on_publishers_id"
  end

  create_table "profiles", id: false, force: :cascade do |t|
    t.string "id"
    t.string "user_id"
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.string "avatar"
    t.text "descritpion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "publishers", id: false, force: :cascade do |t|
    t.string "id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string "id"
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
