class CreateBudgetPlanDetails < ActiveRecord::Migration
  def change
    create_table :budget_plan_details do |t|
      t.date :date
      t.integer :budget_id
      t.string :item_name
      t.integer :item_amount
      t.string :item_note

      t.timestamps
    end
  end
end
