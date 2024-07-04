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

ActiveRecord::Schema[7.1].define(version: 2024_04_20_171850) do
  create_table "appointments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nombre_paciente", null: false
    t.string "clave", null: false
    t.string "consecutivo", null: false
    t.decimal "total_servicios", precision: 10, default: "0", null: false
    t.decimal "total_vendido", precision: 10, default: "0", null: false
    t.integer "estado", default: 0, null: false
    t.integer "promedio", default: 0, null: false
    t.bigint "medical_session_id", null: false
    t.bigint "user_id", null: false
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_by_doctor_at"
    t.datetime "finished_by_doctor_at"
    t.string "atendido_por"
    t.integer "cortesia", default: 0, null: false
    t.string "receta"
    t.text "observacion"
    t.index ["medical_session_id"], name: "index_appointments_on_medical_session_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medical_sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "total_vendido", precision: 10, default: "0", null: false
    t.decimal "total_consultas", precision: 10, default: "0", null: false
    t.decimal "total_otros_servicios", precision: 10, default: "0", null: false
    t.integer "conteo_consultas", default: 0, null: false
    t.integer "conteo_aplicaciones", default: 0, null: false
    t.integer "conteo_otros_servicios", default: 0, null: false
    t.integer "estado", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_acquireds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.bigint "service_id", null: false
    t.decimal "costo", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cantidad", default: 1, null: false
    t.index ["appointment_id"], name: "index_service_acquireds_on_appointment_id"
    t.index ["service_id"], name: "index_service_acquireds_on_service_id"
  end

  create_table "services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.decimal "costo", precision: 10
    t.integer "estado"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "aumentos", default: 0, null: false
    t.index ["category_id"], name: "index_services_on_category_id"
  end

  create_table "user_medical_sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "medical_session_id", null: false
    t.index ["medical_session_id"], name: "index_user_medical_sessions_on_medical_session_id"
    t.index ["user_id"], name: "index_user_medical_sessions_on_user_id"
  end

  create_table "user_type_permissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.bigint "user_type_id", null: false
    t.index ["permission_id"], name: "index_user_type_permissions_on_permission_id"
    t.index ["user_type_id"], name: "index_user_type_permissions_on_user_type_id"
  end

  create_table "user_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nombre", null: false
    t.text "descripcion", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "email", null: false
    t.string "nombre"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.integer "estado", default: 1, null: false
    t.bigint "user_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_type_id"], name: "index_users_on_user_type_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "appointments", "medical_sessions"
  add_foreign_key "appointments", "users"
  add_foreign_key "service_acquireds", "appointments"
  add_foreign_key "service_acquireds", "services"
  add_foreign_key "services", "categories"
  add_foreign_key "user_medical_sessions", "medical_sessions"
  add_foreign_key "user_medical_sessions", "users"
  add_foreign_key "user_type_permissions", "permissions"
  add_foreign_key "user_type_permissions", "user_types"
  add_foreign_key "users", "user_types"
end
