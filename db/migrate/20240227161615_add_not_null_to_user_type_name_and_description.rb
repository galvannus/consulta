class AddNotNullToUserTypeNameAndDescription < ActiveRecord::Migration[7.1]
  def change
    change_column_null :user_types, :nombre, false
    change_column_null :user_types, :descripcion, false
  end
end
