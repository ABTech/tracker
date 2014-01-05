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

ActiveRecord::Schema.define(version: 20140105045703) do

  create_table "accounts", force: true do |t|
    t.string  "name",      null: false
    t.boolean "is_credit", null: false
    t.integer "position",  null: false
  end

  create_table "attachments", force: true do |t|
    t.string   "name"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "event_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "journal_id"
  end

  create_table "bugs", force: true do |t|
    t.integer  "member_id"
    t.datetime "submitted_on"
    t.text     "description",                  null: false
    t.boolean  "confirmed",    default: false, null: false
    t.boolean  "resolved",     default: false, null: false
    t.datetime "resolved_on"
    t.text     "comment"
    t.boolean  "closed",       default: false, null: false
    t.string   "priority"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "comments", force: true do |t|
    t.integer  "member_id"
    t.text     "content"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_forms", force: true do |t|
    t.string "description", null: false
    t.text   "contents",    null: false
  end

  create_table "emails", force: true do |t|
    t.integer  "event_id"
    t.string   "sender",     default: "",    null: false
    t.datetime "timestamp",                  null: false
    t.text     "contents",                   null: false
    t.string   "status",     default: "New", null: false
    t.string   "subject"
    t.string   "message_id",                 null: false
    t.text     "headers"
  end

  add_index "emails", ["contents"], name: "emails_contents_index", type: :fulltext
  add_index "emails", ["event_id"], name: "emails_event_id_index", using: :btree
  add_index "emails", ["sender"], name: "emails_sender_index", using: :btree
  add_index "emails", ["subject"], name: "emails_subject_index", using: :btree

  create_table "equipment", force: true do |t|
    t.integer "parent_id",   null: false
    t.string  "description", null: false
    t.integer "position",    null: false
    t.string  "shortname",   null: false
  end

  add_index "equipment", ["description"], name: "equipment_description_index", using: :btree
  add_index "equipment", ["parent_id"], name: "equipment_parent_id_index", using: :btree

  create_table "equipment_categories", force: true do |t|
    t.string  "name",      null: false
    t.integer "parent_id", null: false
    t.integer "position",  null: false
  end

  add_index "equipment_categories", ["name"], name: "equipment_categories_name_index", using: :btree
  add_index "equipment_categories", ["parent_id"], name: "equipment_categories_parent_id_index", using: :btree

  create_table "equipment_eventdates", id: false, force: true do |t|
    t.integer "eventdate_id", null: false
    t.integer "equipment_id", null: false
  end

  create_table "event_requests", force: true do |t|
    t.string   "contact_name"
    t.string   "contactemail"
    t.string   "contact_phone"
    t.string   "org"
    t.datetime "event_start"
    t.datetime "event_end"
    t.string   "location"
    t.datetime "reservation_start"
    t.datetime "reservation_end"
    t.text     "memo"
    t.string   "oracle_string"
  end

  create_table "event_roles", force: true do |t|
    t.integer "event_id",  null: false
    t.integer "member_id"
    t.string  "role",      null: false
  end

  add_index "event_roles", ["event_id"], name: "event_roles_event_id_index", using: :btree
  add_index "event_roles", ["member_id"], name: "event_roles_member_id_index", using: :btree
  add_index "event_roles", ["role"], name: "event_roles_role_index", using: :btree

  create_table "eventdates", force: true do |t|
    t.integer  "event_id",    null: false
    t.datetime "startdate",   null: false
    t.datetime "enddate",     null: false
    t.datetime "calldate"
    t.datetime "strikedate"
    t.string   "description", null: false
  end

  add_index "eventdates", ["description"], name: "eventdates_description_index", using: :btree
  add_index "eventdates", ["enddate"], name: "eventdates_enddate_index", using: :btree
  add_index "eventdates", ["event_id"], name: "eventdates_event_id_index", using: :btree
  add_index "eventdates", ["startdate"], name: "eventdates_startdate_index", using: :btree

  create_table "eventdates_locations", id: false, force: true do |t|
    t.integer "eventdate_id", null: false
    t.integer "location_id",  null: false
  end

  create_table "events", force: true do |t|
    t.string   "title",           default: "",                null: false
    t.integer  "organization_id", default: 0,                 null: false
    t.string   "status",          default: "Initial Request", null: false
    t.string   "contactemail"
    t.boolean  "blackout",        default: false,             null: false
    t.datetime "updated_on"
    t.boolean  "publish",         default: false
    t.boolean  "rental",                                      null: false
    t.string   "contact_name",    default: "",                null: false
    t.string   "contact_phone",   default: "",                null: false
    t.integer  "price_quote"
    t.text     "notes",                                       null: false
  end

  add_index "events", ["contactemail"], name: "events_contactemail_index", using: :btree
  add_index "events", ["status"], name: "events_status_index", using: :btree
  add_index "events", ["title"], name: "events_title_index", using: :btree

  create_table "invoice_items", force: true do |t|
    t.string  "memo",               null: false
    t.string  "category",           null: false
    t.integer "price_recognized",   null: false
    t.integer "price_unrecognized", null: false
  end

  add_index "invoice_items", ["category"], name: "invoice_items_category_index", using: :btree

  create_table "invoice_lines", force: true do |t|
    t.integer "invoice_id", null: false
    t.string  "memo",       null: false
    t.string  "category",   null: false
    t.float   "price"
    t.integer "quantity",   null: false
    t.text    "notes"
  end

  add_index "invoice_lines", ["invoice_id"], name: "invoice_lines_invoice_id_index", using: :btree

  create_table "invoices", force: true do |t|
    t.datetime "created_at"
    t.integer  "event_id",      null: false
    t.string   "status",        null: false
    t.boolean  "recognized",    null: false
    t.string   "payment_type",  null: false
    t.string   "oracle_string", null: false
    t.text     "memo"
  end

  add_index "invoices", ["event_id"], name: "invoices_event_id_index", using: :btree

  create_table "journals", force: true do |t|
    t.datetime "created_at"
    t.datetime "date",                                                   null: false
    t.string   "memo",                                                   null: false
    t.integer  "invoice_id"
    t.decimal  "amount",           precision: 9, scale: 2, default: 0.0, null: false
    t.datetime "date_paid"
    t.text     "notes"
    t.integer  "account_id",                               default: 1,   null: false
    t.integer  "event_id"
    t.string   "paymeth_category",                         default: ""
  end

  add_index "journals", ["invoice_id"], name: "journals_link_id_index", using: :btree

  create_table "locations", force: true do |t|
    t.string "building", null: false
    t.string "floor",    null: false
    t.string "room",     null: false
    t.text   "details"
  end

  create_table "member_filters", force: true do |t|
    t.string  "name",         default: "new filter", null: false
    t.string  "filterstring"
    t.integer "displaylimit", default: 0,            null: false
    t.integer "member_id",                           null: false
  end

  create_table "members", force: true do |t|
    t.string   "namefirst",                            null: false
    t.string   "namelast",                             null: false
    t.string   "kerbid",                               null: false
    t.string   "namenick",                             null: false
    t.string   "phone",                                null: false
    t.string   "aim",                                  null: false
    t.string   "crypted_password",          limit: 40, null: false
    t.string   "salt",                      limit: 40, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "settingstring"
    t.string   "title"
    t.string   "callsign"
    t.string   "shirt_size",                limit: 20
    t.integer  "ssn"
    t.float    "payrate"
  end

  add_index "members", ["kerbid"], name: "members_kerbid_index", using: :btree
  add_index "members", ["namefirst"], name: "members_namefirst_index", using: :btree
  add_index "members", ["namelast"], name: "members_namelast_index", using: :btree

  create_table "members_roles", id: false, force: true do |t|
    t.integer "member_id", null: false
    t.integer "role_id",   null: false
  end

  add_index "members_roles", ["member_id"], name: "roles_users_FKIndex2", using: :btree
  add_index "members_roles", ["role_id"], name: "roles_users_FKIndex1", using: :btree

  create_table "organizations", force: true do |t|
    t.string  "name",      default: "", null: false
    t.integer "parent_id"
    t.string  "org_email"
  end

  add_index "organizations", ["name"], name: "organizations_name_index", using: :btree

  create_table "pagers", force: true do |t|
    t.string  "pagertype",     null: false
    t.string  "connectionstr", null: false
    t.integer "member_id",     null: false
    t.integer "priority",      null: false
  end

  create_table "pages", force: true do |t|
    t.datetime "created_on"
    t.text     "message",    null: false
    t.integer  "priority",   null: false
    t.integer  "member_id",  null: false
  end

  create_table "permissions", force: true do |t|
    t.string "pattern"
  end

  create_table "permissions_roles", id: false, force: true do |t|
    t.integer "role_id",       null: false
    t.integer "permission_id", null: false
  end

  add_index "permissions_roles", ["permission_id"], name: "permissions_roles_FKIndex1", using: :btree
  add_index "permissions_roles", ["role_id"], name: "permissions_roles_FKIndex2", using: :btree

  create_table "roles", force: true do |t|
    t.string  "name",   limit: 40,                 null: false
    t.string  "info",   limit: 80,                 null: false
    t.boolean "active",            default: false, null: false
  end

  create_table "timecard_entries", force: true do |t|
    t.integer "member_id"
    t.float   "hours"
    t.integer "eventdate_id"
    t.integer "timecard_id"
    t.float   "payrate"
  end

  create_table "timecards", force: true do |t|
    t.datetime "billing_date"
    t.datetime "due_date"
    t.boolean  "submitted"
    t.datetime "start_date"
    t.datetime "end_date"
  end

end
