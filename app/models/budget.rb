class Budget < ActiveRecord::Base
  belongs_to :expense_item

  default_scope { includes(:expense_item) }  
end
