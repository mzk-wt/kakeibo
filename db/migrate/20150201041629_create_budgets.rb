class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.date :date
      t.integer :expense_item_id
      t.integer :amount

      t.timestamps
    end
  end
end
