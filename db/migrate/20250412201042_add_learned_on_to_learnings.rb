class AddLearnedOnToLearnings < ActiveRecord::Migration[8.0]
  def change
    add_column :learnings, :learned_on, :date, null: false, default: -> { 'CURRENT_DATE' }
  end
end
