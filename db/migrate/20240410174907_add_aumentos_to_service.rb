class AddAumentosToService < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :aumentos, :integer, default: 0, null: false
  end
end
