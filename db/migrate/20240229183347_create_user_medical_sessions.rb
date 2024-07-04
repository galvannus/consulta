class CreateUserMedicalSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_medical_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :medical_session, null: false, foreign_key: true

      #t.timestamps
    end
  end
end
