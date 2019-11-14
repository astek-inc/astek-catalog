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

ActiveRecord::Schema.define(version: 2019_11_07_234322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "backing_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "row_order"
    t.index ["deleted_at"], name: "index_backing_types_on_deleted_at"
    t.index ["row_order"], name: "index_backing_types_on_row_order"
  end

  create_table "collections", id: :serial, force: :cascade do |t|
    t.integer "product_category_id"
    t.string "name"
    t.text "description"
    t.integer "lead_time_id"
    t.text "keywords"
    t.boolean "suppress_from_display", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "suppress_sample_option_from_display", default: false, null: false
    t.index ["deleted_at"], name: "index_collections_on_deleted_at"
    t.index ["suppress_from_display"], name: "index_collections_on_suppress_from_display"
  end

  create_table "collections_websites", id: false, force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "website_id", null: false
    t.index ["collection_id", "website_id"], name: "index_collections_websites_on_collection_id_and_website_id"
    t.index ["website_id", "collection_id"], name: "index_collections_websites_on_website_id_and_collection_id"
  end

  create_table "colors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors_variants", id: false, force: :cascade do |t|
    t.integer "variant_id", null: false
    t.integer "color_id", null: false
    t.index ["color_id", "variant_id"], name: "index_colors_variants_on_color_id_and_variant_id"
    t.index ["variant_id", "color_id"], name: "index_colors_variants_on_variant_id_and_color_id"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "iso_name"
    t.string "iso", limit: 2
    t.string "iso3", limit: 3
    t.string "numcode", limit: 3
    t.integer "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_countries_on_deleted_at"
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "code", limit: 3
    t.string "symbol"
    t.string "symbol_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_currencies_on_deleted_at"
  end

  create_table "custom_materials", id: :serial, force: :cascade do |t|
    t.integer "design_id"
    t.integer "substrate_id"
    t.boolean "default_material"
    t.index ["design_id", "substrate_id"], name: "index_custom_materials_on_design_id_and_substrate_id"
    t.index ["substrate_id", "design_id"], name: "index_custom_materials_on_substrate_id_and_design_id"
  end

  create_table "data_migrations", id: false, force: :cascade do |t|
    t.string "version", null: false
    t.index ["version"], name: "unique_data_migrations", unique: true
  end

  create_table "design_properties", id: :serial, force: :cascade do |t|
    t.integer "design_id"
    t.integer "property_id"
    t.string "value"
    t.integer "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["design_id", "property_id"], name: "index_design_properties_on_design_id_and_property_id"
    t.index ["property_id", "design_id"], name: "index_design_properties_on_property_id_and_design_id"
    t.index ["row_order"], name: "index_design_properties_on_row_order"
  end

  create_table "designs", id: :serial, force: :cascade do |t|
    t.integer "collection_id"
    t.string "name"
    t.string "sku"
    t.text "description"
    t.text "keywords"
    t.decimal "price", precision: 8, scale: 2
    t.integer "sale_unit_id"
    t.integer "sale_quantity", default: 1
    t.integer "minimum_quantity", default: 1
    t.boolean "suppress_from_searches", default: false
    t.datetime "available_on"
    t.datetime "expires_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "row_order"
    t.string "master_sku"
    t.string "price_code"
    t.boolean "user_can_select_material"
    t.integer "country_id"
    t.integer "vendor_id"
    t.integer "subcollection_id"
    t.index ["deleted_at"], name: "index_designs_on_deleted_at"
    t.index ["master_sku"], name: "index_designs_on_master_sku"
    t.index ["row_order"], name: "index_designs_on_row_order"
    t.index ["sku"], name: "index_designs_on_sku"
    t.index ["suppress_from_searches"], name: "index_designs_on_suppress_from_searches"
  end

  create_table "designs_styles", id: false, force: :cascade do |t|
    t.integer "design_id", null: false
    t.integer "style_id", null: false
    t.index ["design_id", "style_id"], name: "index_designs_styles_on_design_id_and_style_id"
    t.index ["style_id", "design_id"], name: "index_designs_styles_on_style_id_and_design_id"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "file"
    t.string "type"
    t.integer "owner_id"
    t.integer "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_images_on_deleted_at"
    t.index ["owner_id"], name: "index_images_on_owner_id"
    t.index ["row_order"], name: "index_images_on_row_order"
    t.index ["type"], name: "index_images_on_type"
  end

  create_table "lead_times", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_lead_times_on_deleted_at"
  end

  create_table "product_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_product_categories_on_deleted_at"
  end

  create_table "product_imports", force: :cascade do |t|
    t.string "name", null: false
    t.string "file", null: false
    t.boolean "imported", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "product_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_product_types_on_deleted_at"
  end

  create_table "product_types_variants", id: false, force: :cascade do |t|
    t.integer "variant_id", null: false
    t.integer "product_type_id", null: false
    t.index ["product_type_id", "variant_id"], name: "index_product_types_variants_on_product_type_id_and_variant_id"
    t.index ["variant_id", "product_type_id"], name: "index_product_types_variants_on_variant_id_and_product_type_id"
  end

  create_table "product_types_websites", id: false, force: :cascade do |t|
    t.integer "product_type_id", null: false
    t.integer "website_id", null: false
    t.index ["product_type_id", "website_id"], name: "index_product_types_websites_on_product_type_id_and_website_id"
    t.index ["website_id", "product_type_id"], name: "index_product_types_websites_on_website_id_and_product_type_id"
  end

  create_table "properties", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "presentation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_properties_on_name"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "sale_units", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sale_units_on_deleted_at"
  end

  create_table "seeds", id: :serial, force: :cascade do |t|
    t.string "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_states_on_deleted_at"
  end

  create_table "styles", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcollection_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_subcollection_types_on_deleted_at"
  end

  create_table "subcollections", force: :cascade do |t|
    t.string "name", null: false
    t.integer "subcollection_type_id", null: false
    t.integer "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "substrate_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_substrate_categories_on_deleted_at"
  end

  create_table "substrate_categories_substrates", id: false, force: :cascade do |t|
    t.integer "substrate_id", null: false
    t.integer "substrate_category_id", null: false
    t.index ["substrate_category_id", "substrate_id"], name: "idx_substr_cats_substrs_on_substr_cat_id_and_substr_id"
    t.index ["substrate_id", "substrate_category_id"], name: "idx_substrs_substr_cats_on_substr_id_and_substr_cat_id"
  end

  create_table "substrates", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "keywords"
    t.integer "backing_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "default_custom_material_group"
    t.decimal "custom_material_surcharge", precision: 8, scale: 2
    t.string "display_name"
    t.decimal "weight_per_square_foot", precision: 5, scale: 2
    t.text "display_description"
    t.boolean "display_on_public_sites", default: false
    t.index ["deleted_at"], name: "index_substrates_on_deleted_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "variant_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_variant_types_on_deleted_at"
  end

  create_table "variants", id: :serial, force: :cascade do |t|
    t.integer "design_id"
    t.integer "variant_type_id"
    t.string "name"
    t.text "sku"
    t.integer "product_type_id"
    t.integer "substrate_id"
    t.integer "backing_type_id"
    t.integer "row_order"
    t.string "tearsheet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.decimal "weight", precision: 5, scale: 2
    t.decimal "width", precision: 5, scale: 2
    t.decimal "height", precision: 5, scale: 2
    t.decimal "depth", precision: 5, scale: 2
    t.index ["deleted_at"], name: "index_variants_on_deleted_at"
    t.index ["row_order"], name: "index_variants_on_row_order"
    t.index ["sku"], name: "index_variants_on_sku"
  end

  create_table "vendors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_vendors_on_deleted_at"
  end

  create_table "website_display", force: :cascade do |t|
    t.integer "websiteable_id"
    t.string "websiteable_type"
    t.integer "website_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["website_id"], name: "index_website_display_on_website_id"
    t.index ["websiteable_id"], name: "index_website_display_on_websiteable_id"
  end

  create_table "websites", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_websites_on_deleted_at"
  end

  add_foreign_key "collections", "lead_times"
  add_foreign_key "collections", "product_categories"
  add_foreign_key "designs", "collections"
  add_foreign_key "designs", "countries"
  add_foreign_key "designs", "sale_units"
  add_foreign_key "designs", "subcollections"
  add_foreign_key "designs", "vendors"
  add_foreign_key "product_types", "product_categories"
  add_foreign_key "states", "countries"
  add_foreign_key "substrates", "backing_types"
  add_foreign_key "variants", "backing_types"
  add_foreign_key "variants", "designs"
  add_foreign_key "variants", "product_types"
  add_foreign_key "variants", "substrates"
  add_foreign_key "variants", "variant_types"
end
