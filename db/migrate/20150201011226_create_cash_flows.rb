class CreateCashFlows < ActiveRecord::Migration
  def change
    create_table :cash_flows do |t|
      t.date :date
      t.integer :account_id
      t.string :flow_type
      t.integer :amount
      t.integer :move_to
      t.integer :expense_item_id
      t.text :memo
      t.boolean :credit_card

      t.timestamps
    end
  end
end
