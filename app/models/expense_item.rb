class ExpenseItem < ActiveRecord::Base
  has_many :cash_flow
  has_many :budget
end
