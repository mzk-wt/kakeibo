class CreateExpenseItems < ActiveRecord::Migration
  def change
    create_table :expense_items do |t|
      t.string :name
      t.string :expense_type
      t.string :category
      t.integer :sort

      t.timestamps
    end
  end
end
