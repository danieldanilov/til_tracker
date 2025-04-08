class CreateTils < ActiveRecord::Migration[8.0]
  def change
    create_table :tils do |t|
      t.string :title
      t.text :body
      t.string :tags

      t.timestamps
    end
  end
end
