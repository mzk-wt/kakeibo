require "csv"

# coding: utf-8
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# ------------------------------------------------
# ユーザマスタの初期化
#   model: User
# columns: id(Integer), email(String:DEFAULT '':NOT NULL), encrypted_password(String:DEFAULT '':NOT NULL),
#          reset_password_token(String), reset_password_sent_at(Datetime), remember_created_at(Datetime),
#          sign_in_count(Integer:DEFAULT 0:NOT NULL), current_sign_in_at(Datetime),
#          last_sign_in_at(Datetime), current_sign_in_ip(String),last_sign_in_ip(Strign),
#          created_ati(Datetime), updated_at(Datetime)
# ------------------------------------------------
CSV.foreach('db/init/user.csv') do |row|
  if $. > 2 then
    User.create!(email:                 row[0],
                 password:              row[1],
                 password_confirmation: row[1])
  end
end

# ------------------------------------------------
# 口座マスタの初期化
#   model: Account
# columns: id(Integer), name(String), init_amount(Integer), init_date(Date), current_amount(Integer)
# ------------------------------------------------
CSV.foreach('db/init/account.csv') do |row|
  if $. > 2 then
    Account.create(id:             row[0],
                   name:           row[1],
                   init_amount:    row[2],
                   init_date:      row[3],
                   current_amount: row[2])
  end
end

# ------------------------------------------------
# 費目マスタの初期化
#   model: ExpenseItem
# columns: id(Integer), name(String), expense_type(String), category(String), sort(Integer)
# ------------------------------------------------
CSV.foreach('db/init/expenseitem.csv') do |row|
  if $. > 2 then
    ExpenseItem.create(id:           row[0],
                       name:         row[1],
                       expense_type: row[2],
                       category:     row[3],
                       sort:         row[4])
  end
end

# ------------------------------------------------
# キャッシュフローのデータ移行
# (CSVファイルから)
#   model: CashFlow 
# columns: date(Date), account_id(Integer), flow_type(String), amount(Integer),
#          move_to(Integer), expense_item_id(Integer), memo(Text), credit_card(Boolean) 
# ------------------------------------------------
CSV.foreach('db/init/cashflow.csv') do |row|
  CashFlow.create(date:            row[0],
                  account_id:      row[1],
                  flow_type:       row[2],
                  amount:          row[3],
                  move_to:         row[4],
                  expense_item_id: row[5],
                  memo:            row[6],
                  credit_card:     (row[7] == "1" ? true : false))
end

# ------------------------------------------------
# 口座残高を計算
# ------------------------------------------------
cashflow = CashFlow.all
cashflow.each { |cf|
  account = Account.find(cf.account_id)

  if cf.flow_type == "i"

    account.update(current_amount: account.current_amount + cf.amount)

  elsif cf.flow_type == "o"

    account.update(current_amount: account.current_amount - cf.amount)
    
  elsif cf.flow_type == "m"

    account.update(current_amount: account.current_amount - cf.amount)

    moveto = Account.find(cf.move_to)
    moveto.update(current_amount: moveto.current_amount + cf.amount)
  end
}
