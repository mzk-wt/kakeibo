class CashFlow < ActiveRecord::Base
  belongs_to :account
  belongs_to :expense_item
	belongs_to :move_to_account, :foreign_key => "move_to", :class_name => "Account"

  default_scope { includes(:account, :expense_item, :move_to_account) }
end
