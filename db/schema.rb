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

ActiveRecord::Schema[7.0].define(version: 2024_12_04_165550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_features", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_features_subscription_tiers", force: :cascade do |t|
    t.bigint "app_feature_id", null: false
    t.bigint "subscription_tier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_feature_id"], name: "index_app_features_subscription_tiers_on_app_feature_id"
    t.index ["subscription_tier_id"], name: "index_app_features_subscription_tiers_on_subscription_tier_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "feature_shares", force: :cascade do |t|
    t.string "share_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "registration_id"
    t.bigint "app_feature_id"
    t.index ["app_feature_id"], name: "index_feature_shares_on_app_feature_id"
    t.index ["registration_id"], name: "index_feature_shares_on_registration_id"
  end

  create_table "question_clicks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "question_id"
    t.bigint "registration_id"
    t.index ["question_id"], name: "index_question_clicks_on_question_id"
    t.index ["registration_id"], name: "index_question_clicks_on_registration_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.boolean "is_hidden"
    t.integer "engagement_counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0
  end

  create_table "registrations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "country_code"
    t.bigint "subscription_tier_id", null: false
    t.index ["subscription_tier_id"], name: "index_registrations_on_subscription_tier_id"
  end

  create_table "review_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "review_id"
    t.bigint "registration_id"
    t.index ["registration_id"], name: "index_review_likes_on_registration_id"
    t.index ["review_id"], name: "index_review_likes_on_review_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.integer "order", default: 0
    t.boolean "is_hidden", default: true
    t.integer "engagement_counter", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 50
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "subscription_tiers", force: :cascade do |t|
    t.string "name"
    t.decimal "price_gbp"
    t.string "discount_description"
    t.string "terms_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_role"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "app_features_subscription_tiers", "app_features"
  add_foreign_key "app_features_subscription_tiers", "subscription_tiers"
  add_foreign_key "registrations", "subscription_tiers"
end
