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

ActiveRecord::Schema.define(version: 2021_09_26_025106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addons", force: :cascade do |t|
    t.string "code", null: false
    t.string "description"
    t.integer "creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_addons_on_code", unique: true
    t.index ["creator_id"], name: "index_addons_on_creator_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.integer "advertiser_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_campaigns_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_type", default: 0
    t.boolean "demo", default: false
    t.string "time_zone"
    t.index ["company_type"], name: "index_companies_on_company_type"
    t.index ["demo"], name: "index_companies_on_demo"
    t.index ["name"], name: "index_companies_on_name", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "company_addons", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "addon_id"
    t.integer "creator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addon_id"], name: "index_company_addons_on_addon_id"
    t.index ["company_id", "addon_id"], name: "index_company_addons_on_company_id_and_addon_id", unique: true
    t.index ["company_id"], name: "index_company_addons_on_company_id"
    t.index ["creator_id"], name: "index_company_addons_on_creator_id"
  end

  create_table "credits", force: :cascade do |t|
    t.bigint "company_id"
    t.string "transaction_code", null: false
    t.decimal "amount", precision: 12, scale: 2
    t.string "particulars"
    t.integer "recorder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price_per_credit", precision: 12, scale: 2, default: "1.0"
    t.integer "campaign_id"
    t.index ["campaign_id"], name: "index_credits_on_campaign_id"
    t.index ["company_id", "transaction_code"], name: "index_credits_on_company_id_and_transaction_code"
    t.index ["company_id"], name: "index_credits_on_company_id"
    t.index ["created_at"], name: "index_credits_on_created_at"
    t.index ["recorder_id"], name: "index_credits_on_recorder_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "recordable_id", null: false
    t.string "recordable_type", null: false
    t.string "action", null: false
    t.string "details"
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_events_on_action"
    t.index ["creator_id"], name: "index_events_on_creator_id"
    t.index ["recordable_id", "recordable_type"], name: "index_events_on_recordable_id_and_recordable_type"
  end

  create_table "media_settings", force: :cascade do |t|
    t.bigint "vehicle_route_id"
    t.integer "regular_ads_length", default: 0
    t.integer "regular_ads_segment_length", default: 0
    t.integer "premium_ads_length", default: 0
    t.integer "premium_ads_segment_length", default: 0
    t.integer "onboarding_length", default: 0
    t.integer "offboarding_length", default: 0
    t.integer "arrival_trigger_time", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["vehicle_route_id"], name: "index_media_settings_on_vehicle_route_id", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.bigint "user_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "play_sequence_videos", force: :cascade do |t|
    t.bigint "play_sequence_id"
    t.bigint "video_id"
    t.bigint "playlist_id"
    t.integer "segment", null: false
    t.string "segment_type", limit: 11, null: false
    t.integer "segment_order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "spot_id"
    t.index ["play_sequence_id"], name: "index_play_sequence_videos_on_play_sequence_id"
    t.index ["playlist_id"], name: "index_play_sequence_videos_on_playlist_id"
    t.index ["spot_id"], name: "index_play_sequence_videos_on_spot_id"
    t.index ["video_id"], name: "index_play_sequence_videos_on_video_id"
  end

  create_table "play_sequences", force: :cascade do |t|
    t.bigint "vehicle_id"
    t.integer "time_slot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["status"], name: "index_play_sequences_on_status"
    t.index ["time_slot_id"], name: "index_play_sequences_on_time_slot_id", unique: true
    t.index ["vehicle_id"], name: "index_play_sequences_on_vehicle_id"
  end

  create_table "playlist_videos", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "playlist_id"
    t.bigint "video_id"
    t.integer "play_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_playlist_videos_on_company_id"
    t.index ["playlist_id"], name: "index_playlist_videos_on_playlist_id"
    t.index ["video_id"], name: "index_playlist_videos_on_video_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.integer "status"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "Playlist"
    t.string "channel"
    t.index ["channel"], name: "index_playlists_on_channel"
    t.index ["company_id"], name: "index_playlists_on_company_id"
    t.index ["creator_id"], name: "index_playlists_on_creator_id"
    t.index ["name"], name: "index_playlists_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["status"], name: "index_playlists_on_status"
    t.index ["type"], name: "index_playlists_on_type"
  end

  create_table "record_sequences", force: :cascade do |t|
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "seq", default: 0
    t.index ["record_type", "record_id"], name: "index_record_sequences_on_record_type_and_record_id", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_roles_on_code", unique: true
    t.index ["name"], name: "index_roles_on_name", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "routes", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name", null: false
    t.float "distance", default: 0.0, null: false
    t.string "origin", null: false
    t.string "destination", null: false
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "search_keywords"
    t.float "first_half_distance", default: 0.0
    t.index ["company_id"], name: "index_routes_on_company_id"
    t.index ["creator_id"], name: "index_routes_on_creator_id"
    t.index ["name"], name: "index_routes_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["search_keywords"], name: "index_routes_on_search_keywords", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "spots", force: :cascade do |t|
    t.bigint "time_slot_id"
    t.bigint "campaign_id"
    t.bigint "vehicle_route_schedule_id"
    t.bigint "route_id"
    t.bigint "playlist_id"
    t.string "type", null: false
    t.integer "count"
    t.decimal "cost_per_cpm", precision: 10, scale: 2
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_spots_on_campaign_id"
    t.index ["creator_id"], name: "index_spots_on_creator_id"
    t.index ["playlist_id"], name: "index_spots_on_playlist_id"
    t.index ["route_id"], name: "index_spots_on_route_id"
    t.index ["time_slot_id"], name: "index_spots_on_time_slot_id"
    t.index ["vehicle_route_schedule_id"], name: "index_spots_on_vehicle_route_schedule_id"
  end

  create_table "time_slots", force: :cascade do |t|
    t.bigint "vehicle_id"
    t.bigint "company_id"
    t.bigint "vehicle_route_schedule_id"
    t.bigint "route_id"
    t.integer "available_regular_spots", default: 0
    t.integer "available_premium_spots", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_time_slots_on_company_id"
    t.index ["route_id"], name: "index_time_slots_on_route_id"
    t.index ["vehicle_id"], name: "index_time_slots_on_vehicle_id"
    t.index ["vehicle_route_schedule_id"], name: "index_time_slots_on_vehicle_route_schedule_id", unique: true
  end

  create_table "trip_logs", force: :cascade do |t|
    t.bigint "time_slot_id"
    t.json "trip_info"
    t.json "video_info"
    t.integer "status", default: 0
    t.string "status_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id"
    t.datetime "trip_etd"
    t.datetime "trip_eta"
    t.index ["created_at"], name: "index_trip_logs_on_created_at"
    t.index ["time_slot_id"], name: "index_trip_logs_on_time_slot_id"
    t.index ["vehicle_id", "trip_etd", "trip_eta"], name: "index_trip_logs_on_vehicle_id_and_trip_etd_and_trip_eta"
    t.index ["vehicle_id"], name: "index_trip_logs_on_vehicle_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.bigint "grantor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grantor_id"], name: "index_user_roles_on_grantor_id"
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "company_id"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_signin_at"
    t.string "confirmation_token", default: ""
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.boolean "no_login", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email", "confirmation_token"], name: "index_users_on_email_and_confirmation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["no_login"], name: "index_users_on_no_login"
  end

  create_table "vehicle_route_schedules", force: :cascade do |t|
    t.bigint "vehicle_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "route_id"
    t.integer "status", default: 0
    t.datetime "etd", null: false
    t.datetime "eta", null: false
    t.text "status_text"
    t.integer "creator_id", null: false
    t.index ["creator_id"], name: "index_vehicle_route_schedules_on_creator_id"
    t.index ["eta"], name: "index_vehicle_route_schedules_on_eta"
    t.index ["etd"], name: "index_vehicle_route_schedules_on_etd"
    t.index ["route_id"], name: "index_vehicle_route_schedules_on_route_id"
    t.index ["vehicle_route_id", "etd"], name: "i_vehicle_route_id_and_etd", unique: true
    t.index ["vehicle_route_id"], name: "index_vehicle_route_schedules_on_vehicle_route_id"
  end

  create_table "vehicle_routes", force: :cascade do |t|
    t.bigint "vehicle_id"
    t.bigint "route_id"
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.float "estimated_travel_time", default: 0.0
    t.index ["creator_id"], name: "index_vehicle_routes_on_creator_id"
    t.index ["route_id"], name: "index_vehicle_routes_on_route_id"
    t.index ["status"], name: "index_vehicle_routes_on_status"
    t.index ["vehicle_id", "route_id"], name: "index_vehicle_routes_on_vehicle_id_and_route_id", unique: true
    t.index ["vehicle_id"], name: "index_vehicle_routes_on_vehicle_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.bigint "company_id"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "status", default: 0
    t.string "device_token"
    t.integer "capacity", default: 0
    t.integer "vehicleable_id", default: 0
    t.string "vehicleable_type", null: false
    t.decimal "credits_per_spot", default: "1.0"
    t.datetime "connected_to_node_at"
    t.string "fcm_notification_token"
    t.index ["company_id"], name: "index_vehicles_on_company_id"
    t.index ["creator_id"], name: "index_vehicles_on_creator_id"
    t.index ["device_token"], name: "index_vehicles_on_device_token", unique: true
    t.index ["name"], name: "index_vehicles_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["status"], name: "index_vehicles_on_status"
    t.index ["vehicleable_type", "vehicleable_id"], name: "ix_vehicleable_id_and_type"
  end

  create_table "vessels", force: :cascade do |t|
    t.integer "kind", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kind"], name: "index_vessels_on_kind"
  end

  create_table "video_play_logs", force: :cascade do |t|
    t.bigint "time_slot_id"
    t.bigint "campaign_id"
    t.bigint "video_id"
    t.bigint "vehicle_id"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.bigint "spot_id"
    t.bigint "trip_log_id"
    t.integer "segment"
    t.integer "segment_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_type", default: "", null: false
    t.datetime "trip_etd"
    t.datetime "trip_eta"
    t.bigint "report_id", default: 0
    t.datetime "play_start"
    t.datetime "play_end"
    t.index ["campaign_id"], name: "index_video_play_logs_on_campaign_id"
    t.index ["spot_id"], name: "index_video_play_logs_on_spot_id"
    t.index ["time_slot_id"], name: "index_video_play_logs_on_time_slot_id"
    t.index ["trip_etd", "trip_eta"], name: "index_video_play_logs_on_trip_etd_and_trip_eta"
    t.index ["trip_log_id", "vehicle_id", "video_id", "report_id"], name: "ix_video_play_logs_extract"
    t.index ["trip_log_id"], name: "index_video_play_logs_on_trip_log_id"
    t.index ["vehicle_id"], name: "index_video_play_logs_on_vehicle_id"
    t.index ["video_id"], name: "index_video_play_logs_on_video_id"
    t.index ["video_type"], name: "index_video_play_logs_on_video_type"
  end

  create_table "videos", force: :cascade do |t|
    t.string "name", null: false
    t.integer "status"
    t.datetime "expire_at"
    t.bigint "company_id"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_type"
    t.index ["company_id"], name: "index_videos_on_company_id"
    t.index ["creator_id"], name: "index_videos_on_creator_id"
    t.index ["name"], name: "index_videos_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["status"], name: "index_videos_on_status"
    t.index ["video_type"], name: "index_videos_on_video_type"
  end

  create_table "waypoints", force: :cascade do |t|
    t.bigint "route_id"
    t.string "name", null: false
    t.integer "sequence"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "route_type"
    t.index ["lonlat"], name: "index_waypoints_on_lonlat", using: :gist
    t.index ["name"], name: "index_waypoints_on_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["route_id"], name: "index_waypoints_on_route_id"
    t.index ["route_type", "route_id"], name: "index_waypoints_on_route_type_and_route_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
