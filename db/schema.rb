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

ActiveRecord::Schema.define(version: 20170918123854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_attachments", primary_key: "application_id", force: :cascade do |t|
    t.bigint "attachment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_id"], name: "index_application_attachments_on_attachment_id", unique: true
  end

  create_table "application_categories", force: :cascade do |t|
    t.bigint "application_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id", "category_id"], name: "index_application_categories_on_application_id_and_category_id", unique: true
    t.index ["application_id"], name: "index_application_categories_on_application_id"
    t.index ["category_id"], name: "index_application_categories_on_category_id"
  end

  create_table "applications", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "website", null: false
    t.string "email", null: false
    t.string "address"
    t.string "phone"
    t.date "founded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "summary", null: false
    t.index ["slug"], name: "index_applications_on_slug", unique: true
  end

  create_table "attachments", force: :cascade do |t|
    t.string "filename", null: false
    t.string "original_filename", null: false
    t.string "size", null: false
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "summary", default: "", null: false
    t.index ["title"], name: "index_categories_on_title", unique: true
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_favorites_on_application_id"
    t.index ["user_id", "application_id"], name: "index_favorites_on_user_id_and_application_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "galleries", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_galleries_on_application_id", unique: true
  end

  create_table "gallery_attachments", force: :cascade do |t|
    t.bigint "gallery_id", null: false
    t.bigint "attachment_id", null: false
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id", "attachment_id"], name: "index_gallery_attachments_on_gallery_id_and_attachment_id", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "phone", null: false
    t.string "job_title", null: false
    t.string "organization", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "value", null: false
    t.bigint "user_id", null: false
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_reviews_on_application_id"
    t.index ["user_id", "application_id"], name: "index_reviews_on_user_id_and_application_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "password_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "application_attachments", "applications", on_delete: :cascade
  add_foreign_key "application_attachments", "attachments", on_delete: :cascade
  add_foreign_key "application_categories", "applications", on_delete: :cascade
  add_foreign_key "application_categories", "categories", on_delete: :cascade
  add_foreign_key "favorites", "applications", on_delete: :cascade
  add_foreign_key "favorites", "users", on_delete: :cascade
  add_foreign_key "galleries", "applications", on_delete: :cascade
  add_foreign_key "gallery_attachments", "attachments", on_delete: :cascade
  add_foreign_key "gallery_attachments", "galleries", on_delete: :cascade
  add_foreign_key "profiles", "users", on_delete: :cascade
  add_foreign_key "reviews", "applications", on_delete: :cascade
  add_foreign_key "reviews", "users", on_delete: :nullify
end
