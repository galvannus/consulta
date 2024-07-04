class AddCantidadAndAumentarToServiceAcquired < ActiveRecord::Migration[7.1]
  def change
    add_column :service_acquireds, :cantidad, :integer, default: 1, null: false
  end
end
