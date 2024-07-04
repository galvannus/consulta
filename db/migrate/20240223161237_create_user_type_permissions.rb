class CreateUserTypePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_type_permissions do |t|
      t.references :permission, null: false, foreign_key: true
      t.references :user_type, null: false, foreign_key: true

      #t.timestamps
    end
  end
end
