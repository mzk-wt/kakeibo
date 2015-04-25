class CreateBudgetPlans < ActiveRecord::Migration
  def change
    create_table :budget_plans do |t|
      t.date :date
      t.integer :usable_total
      t.integer :stock_total
      t.integer :budget_total
      t.integer :direct_debit
      t.text :note

      t.timestamps
    end
  end
end
