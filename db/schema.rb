# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171215223017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "keywords"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.string   "slug"
    t.integer  "row_order"
  end

  add_index "categories", ["deleted_at"], name: "index_categories_on_deleted_at", using: :btree
  add_index "categories", ["row_order"], name: "index_categories_on_row_order", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "collections", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.text     "description"
    t.text     "keywords"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.string   "slug"
    t.integer  "row_order"
  end

  add_index "collections", ["deleted_at"], name: "index_collections_on_deleted_at", using: :btree
  add_index "collections", ["row_order"], name: "index_collections_on_row_order", using: :btree
  add_index "collections", ["slug"], name: "index_collections_on_slug", unique: true, using: :btree

  create_table "collections_websites", id: false, force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "website_id",    null: false
  end

  add_index "collections_websites", ["collection_id", "website_id"], name: "index_collections_websites_on_collection_id_and_website_id", using: :btree
  add_index "collections_websites", ["website_id", "collection_id"], name: "index_collections_websites_on_website_id_and_collection_id", using: :btree

  create_table "color_ways", force: :cascade do |t|
    t.integer  "design_id"
    t.string   "name"
    t.text     "sku"
    t.string   "slug"
    t.integer  "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "color_ways", ["deleted_at"], name: "index_color_ways_on_deleted_at", using: :btree
  add_index "color_ways", ["row_order"], name: "index_color_ways_on_row_order", using: :btree
  add_index "color_ways", ["sku"], name: "index_color_ways_on_sku", using: :btree

  create_table "data_migrations", id: false, force: :cascade do |t|
    t.string "version", null: false
  end

  add_index "data_migrations", ["version"], name: "unique_data_migrations", unique: true, using: :btree

  create_table "designs", force: :cascade do |t|
    t.integer  "collection_id"
    t.string   "name"
    t.text     "description"
    t.text     "keywords"
    t.datetime "available_on"
    t.datetime "expires_on"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
    t.string   "slug"
    t.integer  "row_order"
  end

  add_index "designs", ["deleted_at"], name: "index_designs_on_deleted_at", using: :btree
  add_index "designs", ["row_order"], name: "index_designs_on_row_order", using: :btree
  add_index "designs", ["slug"], name: "index_designs_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "file"
    t.string   "type"
    t.integer  "owner_id"
    t.integer  "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "images", ["deleted_at"], name: "index_images_on_deleted_at", using: :btree
  add_index "images", ["owner_id"], name: "index_images_on_owner_id", using: :btree
  add_index "images", ["row_order"], name: "index_images_on_row_order", using: :btree
  add_index "images", ["type"], name: "index_images_on_type", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "websites", force: :cascade do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "websites", ["deleted_at"], name: "index_websites_on_deleted_at", using: :btree

end
