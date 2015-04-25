class Account < ActiveRecord::Base
  has_many :cash_flow
end
