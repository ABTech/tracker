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

ActiveRecord::Schema.define(version: 20151005212917) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.boolean  "is_credit",  limit: 1,   null: false
    t.integer  "position",   limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "name",                    limit: 255, null: false
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size",    limit: 4
    t.datetime "attachment_updated_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "attachable_id",           limit: 4
    t.string   "attachable_type",         limit: 255
  end

  create_table "blackouts", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "event_id",   limit: 4
    t.datetime "startdate",              null: false
    t.datetime "enddate",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blackouts", ["event_id"], name: "index_blackouts_on_event_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "member_id",  limit: 4
    t.text     "content",    limit: 65535, null: false
    t.integer  "event_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_forms", force: :cascade do |t|
    t.string   "description", limit: 255,   null: false
    t.text     "contents",    limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade do |t|
    t.integer  "event_id",    limit: 4
    t.string   "sender",      limit: 255,      default: "",    null: false
    t.datetime "timestamp",                                    null: false
    t.text     "contents",    limit: 16777215,                 null: false
    t.string   "subject",     limit: 255
    t.string   "message_id",  limit: 255,                      null: false
    t.text     "headers",     limit: 65535,                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "unread",      limit: 1,        default: false, null: false
    t.boolean  "sent",        limit: 1,        default: false, null: false
    t.string   "in_reply_to", limit: 255
  end

  add_index "emails", ["contents"], name: "emails_contents_index", type: :fulltext
  add_index "emails", ["event_id"], name: "emails_event_id_index", using: :btree
  add_index "emails", ["sender"], name: "emails_sender_index", using: :btree
  add_index "emails", ["subject"], name: "emails_subject_index", using: :btree

  create_table "equipment", force: :cascade do |t|
    t.string   "description", limit: 255,                 null: false
    t.string   "shortname",   limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",     limit: 1,   default: false, null: false
    t.string   "category",    limit: 255,                 null: false
    t.string   "subcategory", limit: 255
  end

  add_index "equipment", ["description"], name: "equipment_description_index", using: :btree

  create_table "equipment_eventdates", id: false, force: :cascade do |t|
    t.integer "eventdate_id", limit: 4, null: false
    t.integer "equipment_id", limit: 4, null: false
  end

  create_table "event_roles", force: :cascade do |t|
    t.integer  "roleable_id",   limit: 4,   null: false
    t.integer  "member_id",     limit: 4
    t.string   "role",          limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roleable_type", limit: 255, null: false
  end

  add_index "event_roles", ["member_id"], name: "event_roles_member_id_index", using: :btree
  add_index "event_roles", ["role"], name: "event_roles_role_index", using: :btree
  add_index "event_roles", ["roleable_id"], name: "event_roles_event_id_index", using: :btree

  create_table "eventdates", force: :cascade do |t|
    t.integer  "event_id",          limit: 4,                         null: false
    t.datetime "startdate",                                           null: false
    t.datetime "enddate",                                             null: false
    t.datetime "calldate"
    t.datetime "strikedate"
    t.string   "description",       limit: 255,                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calltype",          limit: 255,   default: "blank",   null: false
    t.string   "striketype",        limit: 255,   default: "enddate", null: false
    t.text     "email_description", limit: 65535,                     null: false
    t.boolean  "delta",             limit: 1,     default: true,      null: false
    t.text     "notes",             limit: 65535,                     null: false
  end

  add_index "eventdates", ["description"], name: "eventdates_description_index", using: :btree
  add_index "eventdates", ["enddate"], name: "eventdates_enddate_index", using: :btree
  add_index "eventdates", ["event_id"], name: "eventdates_event_id_index", using: :btree
  add_index "eventdates", ["startdate"], name: "eventdates_startdate_index", using: :btree

  create_table "eventdates_locations", id: false, force: :cascade do |t|
    t.integer "eventdate_id", limit: 4, null: false
    t.integer "location_id",  limit: 4, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",               limit: 255,      default: "",                null: false
    t.integer  "organization_id",     limit: 4,        default: 0,                 null: false
    t.string   "status",              limit: 255,      default: "Initial Request", null: false
    t.string   "contactemail",        limit: 255
    t.datetime "updated_at"
    t.boolean  "publish",             limit: 1,        default: false
    t.boolean  "rental",              limit: 1,                                    null: false
    t.string   "contact_name",        limit: 255,      default: "",                null: false
    t.string   "contact_phone",       limit: 255,      default: "",                null: false
    t.text     "notes",               limit: 16777215,                             null: false
    t.datetime "created_at"
    t.datetime "representative_date",                                              null: false
    t.boolean  "billable",            limit: 1,        default: true,              null: false
    t.boolean  "textable",            limit: 1,        default: false,             null: false
  end

  add_index "events", ["contactemail"], name: "events_contactemail_index", using: :btree
  add_index "events", ["status"], name: "events_status_index", using: :btree
  add_index "events", ["title"], name: "events_title_index", using: :btree

  create_table "invoice_items", force: :cascade do |t|
    t.string   "memo",       limit: 255, null: false
    t.string   "category",   limit: 255, null: false
    t.integer  "price",      limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_items", ["category"], name: "invoice_items_category_index", using: :btree

  create_table "invoice_lines", force: :cascade do |t|
    t.integer  "invoice_id", limit: 4,     null: false
    t.string   "memo",       limit: 255,   null: false
    t.string   "category",   limit: 255,   null: false
    t.float    "price",      limit: 24
    t.integer  "quantity",   limit: 4,     null: false
    t.text     "notes",      limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_lines", ["invoice_id"], name: "invoice_lines_invoice_id_index", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "event_id",      limit: 4,     null: false
    t.string   "status",        limit: 255,   null: false
    t.string   "payment_type",  limit: 255,   null: false
    t.string   "oracle_string", limit: 255,   null: false
    t.text     "memo",          limit: 65535, null: false
    t.datetime "updated_at"
  end

  add_index "invoices", ["event_id"], name: "invoices_event_id_index", using: :btree

  create_table "journals", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "date",                                                                 null: false
    t.string   "memo",             limit: 255,                                         null: false
    t.integer  "invoice_id",       limit: 4
    t.decimal  "amount",                         precision: 9, scale: 2, default: 0.0, null: false
    t.datetime "date_paid"
    t.text     "notes",            limit: 65535,                                       null: false
    t.integer  "account_id",       limit: 4,                             default: 1,   null: false
    t.integer  "event_id",         limit: 4
    t.string   "paymeth_category", limit: 255,                           default: ""
    t.datetime "updated_at"
  end

  add_index "journals", ["invoice_id"], name: "journals_link_id_index", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "building",   limit: 255,                   null: false
    t.string   "room",       limit: 255,                   null: false
    t.text     "details",    limit: 65535,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",    limit: 1,     default: false, null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "namefirst",                 limit: 255,                            null: false
    t.string   "namelast",                  limit: 255,                            null: false
    t.string   "email",                     limit: 255,                            null: false
    t.string   "namenick",                  limit: 255, default: "",               null: false
    t.string   "phone",                     limit: 255,                            null: false
    t.string   "aim",                       limit: 255,                            null: false
    t.string   "encrypted_password",        limit: 128, default: "",               null: false
    t.string   "password_salt",             limit: 255, default: "",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            limit: 255
    t.datetime "remember_token_expires_at"
    t.string   "title",                     limit: 255
    t.string   "callsign",                  limit: 255
    t.string   "shirt_size",                limit: 20
    t.float    "payrate",                   limit: 24
    t.string   "ssn",                       limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             limit: 4,   default: 0,                null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",        limit: 255
    t.string   "last_sign_in_ip",           limit: 255
    t.string   "role",                      limit: 255, default: "general_member", null: false
    t.boolean  "tracker_dev",               limit: 1,   default: false,            null: false
    t.string   "reset_password_token",      limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean  "receives_comment_emails",   limit: 1,   default: false,            null: false
    t.datetime "payroll_paperwork_date"
    t.datetime "ssi_date"
    t.datetime "driving_paperwork_date"
    t.string   "key_possession",            limit: 255, default: "none",           null: false
    t.string   "alternate_email",           limit: 255
  end

  add_index "members", ["email"], name: "members_kerbid_index", using: :btree
  add_index "members", ["namefirst"], name: "members_namefirst_index", using: :btree
  add_index "members", ["namelast"], name: "members_namelast_index", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "",    null: false
    t.integer  "parent_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",    limit: 1,   default: false, null: false
  end

  add_index "organizations", ["name"], name: "organizations_name_index", using: :btree

  create_table "super_tics", force: :cascade do |t|
    t.integer  "member_id",  limit: 4
    t.integer  "day",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "super_tics", ["member_id"], name: "index_super_tics_on_member_id", using: :btree

  create_table "timecard_entries", force: :cascade do |t|
    t.integer  "member_id",    limit: 4
    t.float    "hours",        limit: 24
    t.integer  "eventdate_id", limit: 4
    t.integer  "timecard_id",  limit: 4
    t.float    "payrate",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timecards", force: :cascade do |t|
    t.datetime "billing_date"
    t.datetime "due_date"
    t.boolean  "submitted",    limit: 1, default: false, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
