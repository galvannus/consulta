class AddNullFalseToPermissionFields < ActiveRecord::Migration[7.1]
  def change
    change_column_null :permissions, :nombre, false
    change_column_null :permissions, :descripcion, false
  end
end
