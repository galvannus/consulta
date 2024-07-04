class AddColumnsToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :started_by_doctor_at, :datetime
    add_column :appointments, :finished_by_doctor_at, :datetime
    add_column :appointments, :atendido_por, :string
    add_column :appointments, :cortesia, :integer, default: 0, null: false
    add_column :appointments, :receta, :string
    add_column :appointments, :observacion, :text
  end
end
