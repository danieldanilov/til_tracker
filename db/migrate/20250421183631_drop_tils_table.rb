class DropTilsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :tils
  end
end
