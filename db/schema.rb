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

ActiveRecord::Schema.define(version: 20170814182925) do

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

  create_table "designs", force: :cascade do |t|
    t.integer  "collection_id"
    t.string   "name"
    t.text     "description"
    t.text     "keywords"
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

end
