class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.string :nombre_paciente, null: false
      t.string :clave, null: false
      t.string :consecutivo, null: false
      t.decimal :total_servicios, null: false, default: 0
      t.decimal :total_vendido, null: false, default: 0
      t.integer :estado, null: false, default: 0
      t.integer :promedio, null: false, default: 0
      t.references :medical_session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :finished_at

      t.timestamps
    end
  end
end
