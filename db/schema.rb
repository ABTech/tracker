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

ActiveRecord::Schema.define(version: 20191025045851) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "name",       limit: 255, null: false
    t.boolean  "is_credit",              null: false
    t.integer  "position",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "name",                    limit: 255, null: false
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.index ["attachable_id", "attachable_type"], name: "index_attachments_on_attachable_id_and_attachable_type", using: :btree
  end

  create_table "blackouts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title",      limit: 255
    t.integer  "event_id"
    t.datetime "startdate",              null: false
    t.datetime "enddate",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id"], name: "index_blackouts_on_event_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "member_id"
    t.text     "content",    limit: 16777215, null: false
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id"], name: "index_comments_on_event_id", using: :btree
  end

  create_table "email_forms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "description", limit: 255,      null: false
    t.text     "contents",    limit: 16777215, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "event_id"
    t.string   "sender",      limit: 255,        default: "",    null: false
    t.datetime "timestamp",                                      null: false
    t.text     "contents",    limit: 4294967295,                 null: false
    t.string   "subject",     limit: 255
    t.string   "message_id",  limit: 255,                        null: false
    t.text     "headers",     limit: 16777215,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "unread",                         default: false, null: false
    t.boolean  "sent",                           default: false, null: false
    t.string   "in_reply_to", limit: 255
    t.index ["event_id"], name: "emails_event_id_index", using: :btree
  end

  create_table "equipment", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "description", limit: 255,                 null: false
    t.string   "shortname",   limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",                 default: false, null: false
    t.string   "category",    limit: 255,                 null: false
    t.string   "subcategory", limit: 255
  end

  create_table "equipment_eventdates", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "eventdate_id", null: false
    t.integer "equipment_id", null: false
    t.index ["equipment_id"], name: "index_equipment_eventdates_on_equipment_id", using: :btree
    t.index ["eventdate_id"], name: "index_equipment_eventdates_on_eventdate_id", using: :btree
  end

  create_table "equipment_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "equipment_id"
    t.integer  "event_id"
    t.integer  "quantity"
    t.integer  "eventdate_start_id"
    t.integer  "eventdate_end_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["equipment_id"], name: "index_equipment_events_on_equipment_id", using: :btree
    t.index ["event_id"], name: "index_equipment_events_on_event_id", using: :btree
  end

  create_table "event_role_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "event_role_id", null: false
    t.integer  "member_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["event_role_id"], name: "index_event_role_applications_on_event_role_id", using: :btree
    t.index ["member_id"], name: "index_event_role_applications_on_member_id", using: :btree
  end

  create_table "event_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "roleable_id",                  null: false
    t.integer  "member_id"
    t.string   "role",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roleable_type",                null: false
    t.boolean  "appliable",     default: true, null: false
    t.index ["member_id"], name: "event_roles_member_id_index", using: :btree
    t.index ["role"], name: "event_roles_role_index", using: :btree
    t.index ["roleable_id", "roleable_type"], name: "index_event_roles_on_roleable_id_and_roleable_type", using: :btree
  end

  create_table "eventdates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "event_id",                                               null: false
    t.datetime "startdate",                                              null: false
    t.datetime "enddate",                                                null: false
    t.datetime "calldate"
    t.datetime "strikedate"
    t.string   "description",       limit: 255,                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calltype",          limit: 255,      default: "blank",   null: false
    t.string   "striketype",        limit: 255,      default: "enddate", null: false
    t.text     "email_description", limit: 16777215,                     null: false
    t.boolean  "delta",                              default: true,      null: false
    t.text     "notes",             limit: 16777215,                     null: false
    t.index ["enddate"], name: "eventdates_enddate_index", using: :btree
    t.index ["event_id"], name: "eventdates_event_id_index", using: :btree
    t.index ["startdate"], name: "eventdates_startdate_index", using: :btree
  end

  create_table "eventdates_locations", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "eventdate_id", null: false
    t.integer "location_id",  null: false
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title",               limit: 255,        default: "",                null: false
    t.integer  "organization_id",                        default: 0,                 null: false
    t.string   "status",                                 default: "Initial Request", null: false
    t.string   "contactemail"
    t.datetime "updated_at"
    t.boolean  "publish",                                default: false
    t.boolean  "rental",                                                             null: false
    t.string   "contact_name",        limit: 255,        default: "",                null: false
    t.string   "contact_phone",       limit: 255,        default: "",                null: false
    t.text     "notes",               limit: 4294967295,                             null: false
    t.datetime "created_at"
    t.datetime "representative_date",                                                null: false
    t.boolean  "billable",                               default: true,              null: false
    t.boolean  "textable",                               default: false,             null: false
    t.index ["contactemail"], name: "events_contactemail_index", using: :btree
    t.index ["organization_id"], name: "index_events_on_organization_id", using: :btree
    t.index ["representative_date"], name: "index_events_on_representative_date", using: :btree
    t.index ["status"], name: "events_status_index", using: :btree
  end

  create_table "invoice_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "memo",       limit: 255, null: false
    t.string   "category",   limit: 255, null: false
    t.integer  "price",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_lines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer  "invoice_id",                  null: false
    t.string   "memo",       limit: 255,      null: false
    t.string   "category",   limit: 255,      null: false
    t.float    "price",      limit: 24
    t.integer  "quantity",                    null: false
    t.text     "notes",      limit: 16777215, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["invoice_id"], name: "invoice_lines_invoice_id_index", using: :btree
  end

  create_table "invoices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.datetime "created_at"
    t.integer  "event_id",                       null: false
    t.string   "status",        limit: 255,      null: false
    t.string   "payment_type",  limit: 255,      null: false
    t.string   "oracle_string", limit: 255,      null: false
    t.text     "memo",          limit: 16777215, null: false
    t.datetime "updated_at"
    t.index ["event_id"], name: "invoices_event_id_index", using: :btree
  end

  create_table "journals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.datetime "created_at"
    t.datetime "date",                                                                      null: false
    t.string   "memo",             limit: 255,                                              null: false
    t.integer  "invoice_id"
    t.decimal  "amount",                            precision: 9, scale: 2, default: "0.0", null: false
    t.datetime "date_paid"
    t.text     "notes",            limit: 16777215,                                         null: false
    t.integer  "account_id",                                                default: 1,     null: false
    t.integer  "event_id"
    t.string   "paymeth_category", limit: 255,                              default: ""
    t.datetime "updated_at"
    t.index ["invoice_id"], name: "journals_link_id_index", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "building",   limit: 255,                      null: false
    t.string   "room",       limit: 255,                      null: false
    t.text     "details",    limit: 16777215,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",                     default: false, null: false
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "namefirst",                 limit: 255,                            null: false
    t.string   "namelast",                  limit: 255,                            null: false
    t.string   "email",                                                            null: false
    t.string   "namenick",                  limit: 255, default: "",               null: false
    t.string   "phone",                     limit: 255,                            null: false
    t.string   "encrypted_password",        limit: 128, default: "",               null: false
    t.string   "password_salt",             limit: 255, default: "",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            limit: 255
    t.datetime "remember_token_expires_at"
    t.string   "title",                     limit: 255
    t.string   "callsign",                  limit: 255
    t.string   "shirt_size",                limit: 20
    t.float    "payrate",                   limit: 24,  default: 8.25
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,                null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",        limit: 255
    t.string   "last_sign_in_ip",           limit: 255
    t.string   "role",                      limit: 255, default: "general_member", null: false
    t.boolean  "tracker_dev",                           default: false,            null: false
    t.string   "reset_password_token",      limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean  "receives_comment_emails",               default: false,            null: false
    t.string   "alternate_email",           limit: 255
    t.boolean  "on_payroll",                            default: false,            null: false
    t.string   "pronouns"
    t.string   "favorite_entropy_drink"
    t.string   "major"
    t.string   "grad_year"
    t.string   "interests"
    t.string   "officer_position"
    t.index ["email"], name: "members_kerbid_index", using: :btree
  end

  create_table "organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "name",       limit: 255, default: "",    null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "defunct",                default: false, null: false
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
    t.index ["eventdate_id"], name: "index_timecard_entries_on_eventdate_id", using: :btree
    t.index ["member_id"], name: "index_timecard_entries_on_member_id", using: :btree
    t.index ["timecard_id"], name: "index_timecard_entries_on_timecard_id", using: :btree
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
