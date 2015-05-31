class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :init_amount
      t.date :init_date
      t.integer :current_amount
      t.integer :sort

      t.timestamps
    end
  end
end
