class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :nombre
      t.text :descripcion
      t.decimal :costo
      t.integer :estado
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
