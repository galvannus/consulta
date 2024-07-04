class AddDefaultValueToEstadoOfUsers < ActiveRecord::Migration[7.1]
  
  change_column_default :users, :estado, 1
  
end
