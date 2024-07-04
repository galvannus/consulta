class CreateMedicalSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_sessions do |t|
      t.decimal :total_vendido, null: false, default: 0
      t.decimal :total_consultas, null: false, default: 0
      t.decimal :total_otros_servicios, null: false, default: 0
      t.integer :conteo_consultas, null: false, default: 0
      t.integer :conteo_aplicaciones, null: false, default: 0
      t.integer :conteo_otros_servicios, null: false, default: 0
      t.integer :estado, null: false, default: 0

      t.timestamps
    end
  end
end
