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

ActiveRecord::Schema.define(version: 20151118050513) do

  create_table "account_settings", force: true do |t|
    t.string   "paypal_email"
    t.integer  "withdraw",        default: 0
    t.integer  "user_id"
    t.integer  "account_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_type_id"
    t.string   "payfast_email"
    t.integer  "merchant_id"
    t.string   "merchant_key"
  end

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "ad_sections", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_settings", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "loading",    default: true
    t.integer  "bid_fee",    default: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "ads_click_infos", force: true do |t|
    t.integer  "advertisement_id"
    t.string   "ip"
    t.string   "country_code"
    t.string   "country_name"
    t.string   "region_code"
    t.string   "region_name"
    t.string   "city"
    t.string   "zip_code"
    t.string   "time_zone"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "click_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ads_click_infos", ["advertisement_id"], name: "index_ads_click_infos_on_advertisement_id", using: :btree

  create_table "advertisements", force: true do |t|
    t.string   "campaign_name"
    t.string   "ad_title"
    t.text     "ad_content"
    t.string   "ad_url"
    t.string   "banner_photo"
    t.boolean  "show_continuously",            default: true
    t.datetime "stop_date"
    t.text     "days_week"
    t.text     "ad_sections_ids"
    t.string   "keywords"
    t.float    "budget_per_click",  limit: 24
    t.float    "budget_per_day",    limit: 24
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",                       default: true
    t.integer  "no_of_clicks",                 default: 0
    t.integer  "no_of_views",                  default: 0
    t.boolean  "admin_approved",               default: false
  end

  create_table "attachments", force: true do |t|
    t.integer  "project_id"
    t.string   "file_name"
    t.string   "attach_type"
    t.integer  "user_id"
    t.integer  "bid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "balances", force: true do |t|
    t.integer "user_id"
    t.decimal "amount",  precision: 8, scale: 2, default: 0.0
  end

  create_table "banners", force: true do |t|
    t.string   "slider_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bid_attachments", force: true do |t|
    t.string  "attachment"
    t.integer "bid_id"
    t.string  "file_name"
    t.string  "content_type"
    t.integer "file_size"
  end

  create_table "bid_milestones", force: true do |t|
    t.string  "description"
    t.integer "bid_id"
    t.integer "price"
    t.date    "delivery_date"
  end

  create_table "bids", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "details"
    t.boolean  "accepted",                   default: false
    t.boolean  "withdrawn",                  default: false
    t.boolean  "featured",                   default: false
    t.integer  "estimated_days"
    t.float    "proposed_amount", limit: 24
    t.float    "earned_amount",   limit: 24
    t.boolean  "awarded",                    default: false
    t.boolean  "declined",                   default: false
    t.boolean  "hidden",                     default: false
    t.boolean  "violation",                  default: false
    t.date     "awarded_date"
    t.date     "accepted_date"
    t.date     "declined_date"
    t.integer  "payment_id"
    t.text     "buyer_note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budget_options", force: true do |t|
    t.string   "name"
    t.integer  "project_budget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "budget_options", ["project_budget_id"], name: "index_budget_options_on_project_budget_id", using: :btree

  create_table "business_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_emails", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.boolean  "email_copy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversation_messages", force: true do |t|
    t.integer "conversation_id"
    t.integer "message_id"
  end

  create_table "conversations", force: true do |t|
    t.text     "body"
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "country_code"
    t.integer  "state_id"
    t.integer  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", force: true do |t|
    t.string   "currency_abbrev"
    t.string   "currency_name"
    t.string   "rate"
    t.string   "symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "deposit_invoices", force: true do |t|
    t.integer  "deposit_request_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "transaction_id"
    t.datetime "paid_on"
    t.text     "data"
    t.string   "type"
    t.string   "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deposit_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "balance_id"
    t.string   "amount"
    t.string   "status",     default: "Pending"
    t.string   "type",       default: "PayPal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disputes", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domain_expertises", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "range"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_managements", force: true do |t|
    t.string   "options"
    t.string   "api_user"
    t.string   "api_key"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_active",  default: false
  end

  create_table "email_templates", force: true do |t|
    t.string "template"
    t.text   "content"
    t.string "subject"
  end

  create_table "faq_topics", force: true do |t|
    t.text     "topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "project_id"
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "aggregate"
    t.integer  "quality_work"
    t.integer  "responsiveness"
    t.integer  "professionalism"
    t.integer  "expertise"
    t.integer  "cost"
    t.integer  "schedule"
    t.text     "comment"
    t.integer  "guest_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",        default: false
  end

  create_table "funding_requests", force: true do |t|
    t.integer "user_id"
    t.integer "milestone_id"
    t.date    "sent_at"
    t.string  "status"
    t.string  "type",         default: "PayPal"
  end

  create_table "guest_users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interest_tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learning_faqs", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "membership_plans", force: true do |t|
    t.string   "name"
    t.decimal  "amount",             precision: 10, scale: 0
    t.integer  "highlight_skills"
    t.boolean  "showcase_portfolio",                          default: false
    t.boolean  "higher_search",                               default: false
    t.string   "team_count"
    t.string   "connects"
    t.boolean  "more_connects",                               default: false
    t.boolean  "more_category",                               default: false
    t.boolean  "pricing_view",                                default: false
    t.boolean  "feature_samples",                             default: false
    t.boolean  "escrow_protection",                           default: false
    t.boolean  "wire_transfer",                               default: false
    t.decimal  "service_fee",        precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_attachments", force: true do |t|
    t.integer "message_id"
    t.string  "attachment"
  end

  add_index "message_attachments", ["message_id"], name: "index_message_attachments_on_message_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "from"
    t.integer  "to"
    t.string   "subject"
    t.boolean  "read",              default: false
    t.text     "body"
    t.integer  "created_by"
    t.integer  "sender_message_id"
    t.string   "folder",            default: "sent"
    t.date     "sent_at"
    t.string   "type",              default: "Project"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "other_message_id"
  end

  create_table "milestone_funding_requests", force: true do |t|
    t.integer "user_id"
    t.integer "milestone_id"
    t.date    "sent_at"
    t.string  "type",         default: "PayPal"
  end

  create_table "milestone_invoices", force: true do |t|
    t.integer  "milestone_funding_request_id"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.boolean  "funded",                       default: false
    t.date     "paidOn"
    t.text     "data"
    t.string   "type"
    t.string   "amount"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestone_release_fund_requests", force: true do |t|
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.integer  "milestone_id"
    t.boolean  "released",     default: false
    t.string   "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", force: true do |t|
    t.string   "description"
    t.datetime "delivery_date"
    t.string   "price"
    t.string   "note"
    t.integer  "project_id"
    t.string   "status",         default: "pending"
    t.integer  "created_by"
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.string   "current_url"
    t.string   "paypal_ipn_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "online_users", force: true do |t|
    t.text     "session_id"
    t.string   "user_type",       default: "GUEST"
    t.integer  "user_id",         default: 0
    t.string   "ip_address"
    t.string   "url"
    t.string   "browser_name"
    t.string   "browser_version"
    t.string   "platform"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_balances", force: true do |t|
    t.integer  "payment_id"
    t.string   "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_details", force: true do |t|
    t.integer "payment_id"
    t.text    "data"
  end

  create_table "payment_settings", force: true do |t|
    t.integer  "payment_type_id"
    t.string   "key1"
    t.string   "value1"
    t.string   "key2"
    t.string   "value2"
    t.string   "key3"
    t.string   "value3"
    t.string   "key4"
    t.string   "value4"
    t.string   "key5"
    t.string   "value5"
    t.string   "key6"
    t.string   "value6"
    t.string   "key7"
    t.string   "value7"
    t.string   "key8"
    t.string   "value8"
    t.string   "key9"
    t.boolean  "value9"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.boolean  "active",       default: true
  end

  create_table "payments", force: true do |t|
    t.integer  "to"
    t.string   "type"
    t.string   "klass",                              default: "Milestone"
    t.decimal  "amount",     precision: 8, scale: 2
    t.datetime "approvedOn"
    t.boolean  "approved",                           default: false
    t.integer  "approvedBy"
    t.boolean  "declined",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pending_payments", force: true do |t|
    t.string   "handler"
    t.string   "pay_key"
    t.integer  "handler_id"
    t.boolean  "processed",  default: false
    t.text     "data"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_messages", force: true do |t|
    t.string   "message"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privacies", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_budgets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_files", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "file"
    t.string   "file_name"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_messages", force: true do |t|
    t.integer "project_id"
    t.integer "message_id"
  end

  create_table "project_sellers", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "bid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_time_frames", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_transitions", force: true do |t|
    t.string   "to_state"
    t.text     "metadata"
    t.integer  "sort_key"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_transitions", ["project_id"], name: "index_project_transitions_on_project_id", using: :btree
  add_index "project_transitions", ["sort_key", "project_id"], name: "index_project_transitions_on_sort_key_and_project_id", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "project_photo"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.string   "project_tag_ids"
    t.string   "skill_tags_ids"
    t.integer  "budget_option_id"
    t.integer  "project_time_frame_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "country_id"
    t.integer  "state_id"
    t.string   "city"
    t.integer  "zip_code"
    t.integer  "user_id"
    t.boolean  "visible",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "rehire_project",        default: false
    t.integer  "rehired_freelancer"
    t.string   "reserve_price"
    t.string   "auction_used"
    t.integer  "affliate_code"
    t.string   "provenance"
    t.string   "item_current_location"
    t.integer  "business_type_id"
  end

  create_table "regular_faqs", force: true do |t|
    t.integer  "role"
    t.text     "question"
    t.text     "answer"
    t.string   "topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_violations", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "project_id"
    t.integer  "bid_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skill_tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.integer  "country_id"
    t.string   "state_name"
    t.string   "state_code"
    t.integer  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", force: true do |t|
    t.text     "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.text     "comment"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "theme_settings", force: true do |t|
    t.integer  "theme_id",   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
  end

  create_table "themes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "us_zipcodes", force: true do |t|
    t.string   "ZIPCode"
    t.string   "ZIPCodeType"
    t.string   "City"
    t.string   "CityType"
    t.string   "State"
    t.string   "StateCode"
    t.string   "AreaCode"
    t.integer  "Latitude",    default: 0
    t.integer  "Longitude",   default: 0
    t.string   "timezone"
    t.string   "dst"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_biographies", force: true do |t|
    t.integer  "user_id"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_biographies", ["user_id"], name: "index_user_biographies_on_user_id", using: :btree

  create_table "user_degrees", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_educations", force: true do |t|
    t.integer  "user_id"
    t.string   "college_name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "degree_id"
    t.string   "field_of_study"
    t.text     "activities_societies"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_educations", ["degree_id"], name: "index_user_educations_on_degree_id", using: :btree
  add_index "user_educations", ["user_id"], name: "index_user_educations_on_user_id", using: :btree

  create_table "user_experiences", force: true do |t|
    t.integer  "user_id"
    t.string   "company_name"
    t.string   "job_title"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_experiences", ["user_id"], name: "index_user_experiences_on_user_id", using: :btree

  create_table "user_membership_plans", force: true do |t|
    t.integer  "user_id"
    t.integer  "membership_plan_id"
    t.datetime "start_date"
    t.datetime "expire_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "payment_method",     default: true
    t.boolean  "auto_renewal",       default: false
  end

  create_table "user_messages", force: true do |t|
    t.integer "message_id"
    t.integer "user_id"
  end

  create_table "user_skills", force: true do |t|
    t.integer  "user_id"
    t.string   "known_skills"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "phone"
    t.string   "display_name"
    t.integer  "country_id"
    t.string   "state_id"
    t.string   "zipcode"
    t.string   "city"
    t.string   "address"
    t.integer  "role_id"
    t.string   "profile_photo"
    t.string   "video_url"
    t.string   "time_zone"
    t.string   "lat"
    t.string   "lng"
    t.string   "currency"
    t.integer  "business_started"
    t.text     "category_ids"
    t.boolean  "notify_category"
    t.boolean  "day_light_saving"
    t.string   "tagline"
    t.float    "hourly_rate",            limit: 24
    t.text     "summary"
    t.text     "detail_info"
    t.text     "skill_ids"
    t.boolean  "notify_skill"
    t.text     "notify_emails"
    t.boolean  "approved",                                                   default: false
    t.boolean  "visible",                                                    default: true
    t.string   "email",                                                      default: "",    null: false
    t.string   "encrypted_password",                                         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",                                                  default: true
    t.integer  "braintree_customer_id"
    t.boolean  "priority",                                                   default: false
    t.integer  "membership_renewal"
    t.integer  "user_id",                                                    default: 0
    t.integer  "ref_id"
    t.integer  "total_connects",                                             default: 0
    t.integer  "used_connects",                                              default: 0
    t.integer  "bonus_connects",                                             default: 0
    t.boolean  "search_priority",                                            default: false
    t.boolean  "referral_bonus",                                             default: false
    t.decimal  "referral_amount",                   precision: 10, scale: 0, default: 0
    t.string   "referral_source"
    t.string   "provider"
    t.string   "uid"
    t.string   "interest_tag_ids"
    t.string   "company_name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "withdrawal_balances", force: true do |t|
    t.integer  "withdrawal_id"
    t.string   "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "withdrawal_invoices", force: true do |t|
    t.integer  "withdrawal_request_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "transaction_id"
    t.date     "paid_on"
    t.text     "data"
    t.string   "type"
    t.string   "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "withdrawal_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "balance_id"
    t.string   "amount"
    t.string   "status",        default: "Pending"
    t.string   "type",          default: "PayPal"
    t.string   "withdraw_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
