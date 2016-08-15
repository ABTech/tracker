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

ActiveRecord::Schema.define(version: 20160815162731) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "name",       null: false
    t.boolean  "is_credit",  null: false
    t.integer  "position",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "name",                                null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "attachable_id"
    t.string   "attachable_type",         limit: 191
  end

  create_table "blackouts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title"
    t.integer  "event_id"
    t.datetime "startdate",  null: false
    t.datetime "enddate",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id"], name: "index_blackouts_on_event_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "member_id"
    t.text     "content",    limit: 4294967295, null: false
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_forms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "description",                    null: false
    t.text     "contents",    limit: 4294967295, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "event_id"
    t.string   "sender",                         default: "",    null: false
    t.datetime "timestamp",                                      null: false
    t.text     "contents",    limit: 4294967295,                 null: false
    t.string   "subject"
    t.string   "message_id",                                     null: false
    t.text     "headers",     limit: 4294967295,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "unread",                         default: false, null: false
    t.boolean  "sent",                           default: false, null: false
    t.string   "in_reply_to"
    t.index ["event_id"], name: "emails_event_id_index", using: :btree
  end

  create_table "equipment", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "description",                 null: false
    t.string   "shortname",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",     default: false, null: false
    t.string   "category",                    null: false
    t.string   "subcategory"
  end

  create_table "equipment_eventdates", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "eventdate_id", null: false
    t.integer "equipment_id", null: false
  end

  create_table "event_role_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "event_role_id", null: false
    t.integer  "member_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "event_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "roleable_id",               null: false
    t.integer  "member_id"
    t.string   "role",          limit: 191, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roleable_type", limit: 191, null: false
    t.index ["member_id"], name: "event_roles_member_id_index", using: :btree
    t.index ["role"], name: "event_roles_role_index", using: :btree
    t.index ["roleable_id"], name: "event_roles_event_id_index", using: :btree
  end

  create_table "eventdates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "event_id",                                                 null: false
    t.datetime "startdate",                                                null: false
    t.datetime "enddate",                                                  null: false
    t.datetime "calldate"
    t.datetime "strikedate"
    t.string   "description",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calltype",                             default: "blank",   null: false
    t.string   "striketype",                           default: "enddate", null: false
    t.text     "email_description", limit: 4294967295,                     null: false
    t.boolean  "delta",                                default: true,      null: false
    t.text     "notes",             limit: 4294967295,                     null: false
    t.index ["enddate"], name: "eventdates_enddate_index", using: :btree
    t.index ["event_id"], name: "eventdates_event_id_index", using: :btree
    t.index ["startdate"], name: "eventdates_startdate_index", using: :btree
  end

  create_table "eventdates_locations", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "eventdate_id", null: false
    t.integer "location_id",  null: false
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title",                                  default: "",                null: false
    t.integer  "organization_id",                        default: 0,                 null: false
    t.string   "status",              limit: 191,        default: "Initial Request", null: false
    t.string   "contactemail",        limit: 191
    t.datetime "updated_at"
    t.boolean  "publish",                                default: false
    t.boolean  "rental",                                                             null: false
    t.string   "contact_name",                           default: "",                null: false
    t.string   "contact_phone",                          default: "",                null: false
    t.text     "notes",               limit: 4294967295,                             null: false
    t.datetime "created_at"
    t.datetime "representative_date",                                                null: false
    t.boolean  "billable",                               default: true,              null: false
    t.boolean  "textable",                               default: false,             null: false
    t.index ["contactemail"], name: "events_contactemail_index", using: :btree
    t.index ["status"], name: "events_status_index", using: :btree
  end

  create_table "invoice_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "memo",       null: false
    t.string   "category",   null: false
    t.integer  "price",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_lines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "invoice_id",                    null: false
    t.string   "memo",                          null: false
    t.string   "category",                      null: false
    t.float    "price",      limit: 24
    t.integer  "quantity",                      null: false
    t.text     "notes",      limit: 4294967295, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["invoice_id"], name: "invoice_lines_invoice_id_index", using: :btree
  end

  create_table "invoices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.datetime "created_at"
    t.integer  "event_id",                         null: false
    t.string   "status",                           null: false
    t.string   "payment_type",                     null: false
    t.string   "oracle_string",                    null: false
    t.text     "memo",          limit: 4294967295, null: false
    t.datetime "updated_at"
    t.index ["event_id"], name: "invoices_event_id_index", using: :btree
  end

  create_table "journals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.datetime "created_at"
    t.datetime "date",                                                                        null: false
    t.string   "memo",                                                                        null: false
    t.integer  "invoice_id"
    t.decimal  "amount",                              precision: 9, scale: 2, default: "0.0", null: false
    t.datetime "date_paid"
    t.text     "notes",            limit: 4294967295,                                         null: false
    t.integer  "account_id",                                                  default: 1,     null: false
    t.integer  "event_id"
    t.string   "paymeth_category",                                            default: ""
    t.datetime "updated_at"
    t.index ["invoice_id"], name: "journals_link_id_index", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "building",                                      null: false
    t.string   "room",                                          null: false
    t.text     "details",    limit: 4294967295,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",                       default: false, null: false
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "namefirst",                                                        null: false
    t.string   "namelast",                                                         null: false
    t.string   "email",                     limit: 191,                            null: false
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
    t.float    "payrate",                   limit: 24
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
    t.boolean  "receives_comment_emails",               default: false,            null: false
    t.datetime "payroll_paperwork_date"
    t.datetime "ssi_date"
    t.datetime "driving_paperwork_date"
    t.string   "key_possession",                        default: "none",           null: false
    t.string   "alternate_email"
    t.index ["email"], name: "members_kerbid_index", using: :btree
  end

  create_table "organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "name",       default: "",    null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",    default: false, null: false
    t.index ["name"], name: "organizations_name_index", using: :btree
  end

  create_table "super_tics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "member_id"
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["member_id"], name: "index_super_tics_on_member_id", using: :btree
  end

  create_table "timecard_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "member_id"
    t.float    "hours",        limit: 24
    t.integer  "eventdate_id"
    t.integer  "timecard_id"
    t.float    "payrate",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timecards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.datetime "billing_date"
    t.datetime "due_date"
    t.boolean  "submitted",    default: false, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
