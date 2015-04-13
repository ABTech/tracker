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

ActiveRecord::Schema.define(version: 20150412202155) do

  create_table "accounts", force: true do |t|
    t.string   "name",       null: false
    t.boolean  "is_credit",  null: false
    t.integer  "position",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.string   "name",                    null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "event_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "journal_id"
  end

  create_table "blackouts", force: true do |t|
    t.string   "title"
    t.integer  "event_id"
    t.datetime "startdate",  null: false
    t.datetime "enddate",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blackouts", ["event_id"], name: "index_blackouts_on_event_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "member_id"
    t.text     "content",    null: false
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_forms", force: true do |t|
    t.string   "description", null: false
    t.text     "contents",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: true do |t|
    t.integer  "event_id"
    t.string   "sender",                      default: "",    null: false
    t.datetime "timestamp",                                   null: false
    t.text     "contents",   limit: 16777215,                 null: false
    t.string   "status",                      default: "New", null: false
    t.string   "subject"
    t.string   "message_id",                                  null: false
    t.text     "headers",                                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["contents"], name: "emails_contents_index", type: :fulltext
  add_index "emails", ["event_id"], name: "emails_event_id_index", using: :btree
  add_index "emails", ["sender"], name: "emails_sender_index", using: :btree
  add_index "emails", ["subject"], name: "emails_subject_index", using: :btree

  create_table "equipment", force: true do |t|
    t.integer  "parent_id",                   null: false
    t.string   "description",                 null: false
    t.integer  "position",                    null: false
    t.string   "shortname",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",     default: false, null: false
  end

  add_index "equipment", ["description"], name: "equipment_description_index", using: :btree
  add_index "equipment", ["parent_id"], name: "equipment_parent_id_index", using: :btree

  create_table "equipment_categories", force: true do |t|
    t.string   "name",       null: false
    t.integer  "parent_id",  null: false
    t.integer  "position",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "equipment_categories", ["name"], name: "equipment_categories_name_index", using: :btree
  add_index "equipment_categories", ["parent_id"], name: "equipment_categories_parent_id_index", using: :btree

  create_table "equipment_eventdates", id: false, force: true do |t|
    t.integer "eventdate_id", null: false
    t.integer "equipment_id", null: false
  end

  create_table "event_roles", force: true do |t|
    t.integer  "roleable_id",   null: false
    t.integer  "member_id"
    t.string   "role",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roleable_type", null: false
  end

  add_index "event_roles", ["member_id"], name: "event_roles_member_id_index", using: :btree
  add_index "event_roles", ["role"], name: "event_roles_role_index", using: :btree
  add_index "event_roles", ["roleable_id"], name: "event_roles_event_id_index", using: :btree

  create_table "eventdates", force: true do |t|
    t.integer  "event_id",                              null: false
    t.datetime "startdate",                             null: false
    t.datetime "enddate",                               null: false
    t.datetime "calldate"
    t.datetime "strikedate"
    t.string   "description",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calltype",          default: "blank",   null: false
    t.string   "striketype",        default: "enddate", null: false
    t.text     "email_description",                     null: false
    t.boolean  "delta",             default: true,      null: false
    t.text     "notes",                                 null: false
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
    t.string   "title",                                default: "",                null: false
    t.integer  "organization_id",                      default: 0,                 null: false
    t.string   "status",                               default: "Initial Request", null: false
    t.string   "contactemail"
    t.datetime "updated_at"
    t.boolean  "publish",                              default: false
    t.boolean  "rental",                                                           null: false
    t.string   "contact_name",                         default: "",                null: false
    t.string   "contact_phone",                        default: "",                null: false
    t.integer  "price_quote"
    t.text     "notes",               limit: 16777215,                             null: false
    t.datetime "created_at"
    t.datetime "representative_date",                                              null: false
    t.boolean  "billable",                             default: true,              null: false
    t.boolean  "textable",                             default: false,             null: false
  end

  add_index "events", ["contactemail"], name: "events_contactemail_index", using: :btree
  add_index "events", ["status"], name: "events_status_index", using: :btree
  add_index "events", ["title"], name: "events_title_index", using: :btree

  create_table "invoice_items", force: true do |t|
    t.string   "memo",       null: false
    t.string   "category",   null: false
    t.integer  "price",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_items", ["category"], name: "invoice_items_category_index", using: :btree

  create_table "invoice_lines", force: true do |t|
    t.integer  "invoice_id", null: false
    t.string   "memo",       null: false
    t.string   "category",   null: false
    t.float    "price"
    t.integer  "quantity",   null: false
    t.text     "notes",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_lines", ["invoice_id"], name: "invoice_lines_invoice_id_index", using: :btree

  create_table "invoices", force: true do |t|
    t.datetime "created_at"
    t.integer  "event_id",      null: false
    t.string   "status",        null: false
    t.string   "payment_type",  null: false
    t.string   "oracle_string", null: false
    t.text     "memo",          null: false
    t.datetime "updated_at"
  end

  add_index "invoices", ["event_id"], name: "invoices_event_id_index", using: :btree

  create_table "journals", force: true do |t|
    t.datetime "created_at"
    t.datetime "date",                                                   null: false
    t.string   "memo",                                                   null: false
    t.integer  "invoice_id"
    t.decimal  "amount",           precision: 9, scale: 2, default: 0.0, null: false
    t.datetime "date_paid"
    t.text     "notes",                                                  null: false
    t.integer  "account_id",                               default: 1,   null: false
    t.integer  "event_id"
    t.string   "paymeth_category",                         default: ""
    t.datetime "updated_at"
  end

  add_index "journals", ["invoice_id"], name: "journals_link_id_index", using: :btree

  create_table "locations", force: true do |t|
    t.string   "building",                   null: false
    t.string   "room",                       null: false
    t.text     "details",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",    default: false, null: false
  end

  create_table "members", force: true do |t|
    t.string   "namefirst",                                                        null: false
    t.string   "namelast",                                                         null: false
    t.string   "email",                                                            null: false
    t.string   "namenick",                              default: "",               null: false
    t.string   "phone",                                                            null: false
    t.string   "aim",                                                              null: false
    t.string   "encrypted_password",        limit: 128, default: "",               null: false
    t.string   "password_salt",                         default: "",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "title"
    t.string   "callsign"
    t.string   "shirt_size",                limit: 20
    t.float    "payrate"
    t.string   "ssn"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,                null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role",                                  default: "general_member", null: false
    t.boolean  "tracker_dev",                           default: false,            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_index "members", ["email"], name: "members_kerbid_index", using: :btree
  add_index "members", ["namefirst"], name: "members_namefirst_index", using: :btree
  add_index "members", ["namelast"], name: "members_namelast_index", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",       default: "",    null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",    default: false, null: false
  end

  add_index "organizations", ["name"], name: "organizations_name_index", using: :btree

  create_table "timecard_entries", force: true do |t|
    t.integer  "member_id"
    t.float    "hours"
    t.integer  "eventdate_id"
    t.integer  "timecard_id"
    t.float    "payrate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timecards", force: true do |t|
    t.datetime "billing_date"
    t.datetime "due_date"
    t.boolean  "submitted",    default: false, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
