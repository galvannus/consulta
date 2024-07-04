class CreateServiceAcquireds < ActiveRecord::Migration[7.1]
  def change
    create_table :service_acquireds do |t|
      t.references :appointment, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.decimal :costo
      
      t.timestamps
    end
  end
end
