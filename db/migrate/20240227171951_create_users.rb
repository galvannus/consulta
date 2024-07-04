class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :nombre
      t.string :apellido_paterno
      t.string :apellido_materno
      t.integer :estado
      t.references :user_type, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
