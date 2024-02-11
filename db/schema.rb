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

ActiveRecord::Schema.define(version: 2023_11_13_195629) do

  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.boolean "is_credit", null: false
    t.integer "position", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "attachment_file_name", limit: 255
    t.string "attachment_content_type", limit: 255
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer "attachable_id"
    t.string "attachable_type"
    t.index ["attachable_id", "attachable_type"], name: "index_attachments_on_attachable_id_and_attachable_type"
  end

  create_table "blackouts", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "event_id"
    t.datetime "startdate", null: false
    t.datetime "enddate", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id"], name: "index_blackouts_on_event_id"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "member_id"
    t.text "content", size: :medium, null: false
    t.integer "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id"], name: "index_comments_on_event_id"
  end

  create_table "email_forms", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "description", limit: 255, null: false
    t.text "contents", size: :medium, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "event_id"
    t.string "sender", limit: 255, default: "", null: false
    t.datetime "timestamp", null: false
    t.text "contents", size: :long, null: false
    t.string "subject", limit: 255
    t.string "message_id", limit: 255, null: false
    t.text "headers", size: :medium, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "unread", default: false, null: false
    t.boolean "sent", default: false, null: false
    t.string "in_reply_to", limit: 255
    t.index ["event_id"], name: "emails_event_id_index"
  end

  create_table "equipment_profiles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "description", limit: 255, null: false
    t.string "shortname", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "defunct", default: false, null: false
    t.string "category", limit: 255, null: false
    t.string "subcategory", limit: 255
  end

  create_table "equipment_profiles_eventdates", id: false, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "eventdate_id", null: false
    t.integer "equipment_profile_id", null: false
    t.index ["equipment_profile_id"], name: "index_equipment_profiles_eventdates_on_equipment_profile_id"
    t.index ["eventdate_id"], name: "index_equipment_profiles_eventdates_on_eventdate_id"
  end

  create_table "equipment_profiles_events", charset: "latin1", force: :cascade do |t|
    t.integer "equipment_profile_id"
    t.integer "event_id"
    t.integer "quantity"
    t.integer "eventdate_start_id"
    t.integer "eventdate_end_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["equipment_profile_id"], name: "index_equipment_profiles_events_on_equipment_profile_id"
    t.index ["event_id"], name: "index_equipment_profiles_events_on_event_id"
  end

  create_table "event_role_applications", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "event_role_id", null: false
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_role_id"], name: "index_event_role_applications_on_event_role_id"
    t.index ["member_id"], name: "index_event_role_applications_on_member_id"
  end

  create_table "event_roles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "roleable_id", null: false
    t.integer "member_id"
    t.string "role", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "roleable_type", null: false
    t.boolean "appliable", default: true, null: false
    t.string "level"
    t.index ["member_id"], name: "event_roles_member_id_index"
    t.index ["role"], name: "event_roles_role_index"
    t.index ["roleable_id", "roleable_type"], name: "index_event_roles_on_roleable_id_and_roleable_type"
  end

  create_table "eventdates", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "event_id", null: false
    t.datetime "startdate", null: false
    t.datetime "enddate", null: false
    t.datetime "calldate"
    t.datetime "strikedate"
    t.string "description", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "calltype", default: "blank_call", null: false
    t.string "striketype", limit: 255, default: "enddate", null: false
    t.text "email_description", size: :medium, null: false
    t.boolean "delta", default: true, null: false
    t.text "notes", size: :medium, null: false
    t.boolean "billable_call", default: true
    t.boolean "billable_show", default: true
    t.boolean "billable_strike", default: true
    t.index ["enddate"], name: "eventdates_enddate_index"
    t.index ["event_id"], name: "eventdates_event_id_index"
    t.index ["startdate"], name: "eventdates_startdate_index"
  end

  create_table "eventdates_locations", id: false, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "eventdate_id", null: false
    t.integer "location_id", null: false
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "title", limit: 255, default: "", null: false
    t.integer "organization_id", default: 0, null: false
    t.string "status", default: "Initial Request", null: false
    t.string "contactemail"
    t.datetime "updated_at"
    t.boolean "publish", default: false
    t.boolean "rental", null: false
    t.string "contact_name", limit: 255, default: "", null: false
    t.string "contact_phone", limit: 255, default: "", null: false
    t.text "notes", size: :long, null: false
    t.datetime "created_at"
    t.datetime "representative_date", null: false
    t.boolean "billable", default: true, null: false
    t.boolean "textable", default: false, null: false
    t.boolean "textable_social", default: false, null: false
    t.datetime "last_representative_date"
    t.index ["contactemail"], name: "events_contactemail_index"
    t.index ["last_representative_date"], name: "index_events_on_last_representative_date"
    t.index ["organization_id"], name: "index_events_on_organization_id"
    t.index ["representative_date"], name: "index_events_on_representative_date"
    t.index ["status"], name: "events_status_index"
  end

  create_table "invoice_contacts", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "email", null: false
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_invoice_contacts_on_email", unique: true
  end

  create_table "invoice_items", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "memo", limit: 255, null: false
    t.string "category", limit: 255, null: false
    t.integer "price", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_lines", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.string "memo", limit: 255, null: false
    t.string "category", limit: 255, null: false
    t.float "price"
    t.integer "quantity", null: false
    t.text "notes", size: :medium, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "line_no"
    t.index ["invoice_id"], name: "invoice_lines_invoice_id_index"
  end

  create_table "invoices", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "event_id", null: false
    t.string "status", limit: 255, null: false
    t.string "payment_type", limit: 255, null: false
    t.string "oracle_string", limit: 255, null: false
    t.text "memo", size: :medium, null: false
    t.datetime "updated_at"
    t.index ["event_id"], name: "invoices_event_id_index"
  end

  create_table "journals", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "date", null: false
    t.string "memo", limit: 255, null: false
    t.integer "invoice_id"
    t.decimal "amount", precision: 9, scale: 2, default: "0.0", null: false
    t.datetime "date_paid"
    t.text "notes", size: :medium, null: false
    t.integer "account_id", default: 1, null: false
    t.integer "event_id"
    t.string "paymeth_category", limit: 255, default: ""
    t.datetime "updated_at"
    t.index ["invoice_id"], name: "journals_link_id_index"
  end

  create_table "kiosks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "hostname", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "show_header_time", default: true, null: false
    t.boolean "show_header_network_status", default: true, null: false
    t.boolean "ability_read_equipment", default: false, null: false
    t.boolean "ability_index_weather", default: false, null: false
    t.index ["hostname"], name: "index_kiosks_on_hostname", unique: true
  end

  create_table "locations", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "building", limit: 255, null: false
    t.string "room", limit: 255, null: false
    t.text "details", size: :medium, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "defunct", default: false, null: false
  end

  create_table "members", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "namefirst", limit: 255, null: false
    t.string "namelast", limit: 255, null: false
    t.string "email", null: false
    t.string "namenick", limit: 255, default: "", null: false
    t.string "phone", limit: 255, null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "password_salt", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token", limit: 255
    t.datetime "remember_token_expires_at"
    t.string "title", limit: 255
    t.string "callsign", limit: 255
    t.string "shirt_size", limit: 20
    t.float "payrate", default: 8.25
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "role", limit: 255, default: "general_member", null: false
    t.boolean "tracker_dev", default: false, null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean "receives_comment_emails", default: false, null: false
    t.string "alternate_email", limit: 255
    t.boolean "on_payroll", default: false, null: false
    t.string "pronouns"
    t.string "favorite_entropy_drink"
    t.string "major"
    t.string "grad_year"
    t.string "interests"
    t.string "officer_position"
    t.index ["email"], name: "members_kerbid_index"
  end

  create_table "organizations", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.integer "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "defunct", default: false, null: false
  end

  create_table "super_tics", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "member_id"
    t.integer "day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["member_id"], name: "index_super_tics_on_member_id"
  end

  create_table "timecard_entries", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "member_id"
    t.float "hours"
    t.bigint "eventdate_id"
    t.integer "timecard_id"
    t.float "payrate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "eventpart"
    t.index ["eventdate_id"], name: "index_timecard_entries_on_eventdate_id"
    t.index ["member_id"], name: "index_timecard_entries_on_member_id"
    t.index ["timecard_id"], name: "index_timecard_entries_on_timecard_id"
  end

  create_table "timecards", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "billing_date"
    t.datetime "due_date"
    t.boolean "submitted", default: false, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "timecard_entries", "eventdates"
end
