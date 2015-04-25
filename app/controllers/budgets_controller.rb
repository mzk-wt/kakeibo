class BudgetsController < ApplicationController

  def index
    # 表示対象の年月日
    @cal = getCalendar()

    # 指定月の範囲
    dateFrom = @cal.beginning_of_month
    dateTo = @cal.end_of_month

    # 口座情報
    @account = Account.all.order(id: :asc)

    # 費目一覧
    @expenseItem = ExpenseItem.where(expense_type: 'o').order(sort: :asc)

    # 予算情報
    @budget = Budget.where(date: dateFrom..dateTo)
  end

  def lumpUpdate
    # 表示対象の年月日
    @cal = getCalendar()

    # 指定月の範囲
    dateFrom = @cal.beginning_of_month
    dateTo = @cal.end_of_month
    
    # 指定月の予算レコードを取得
    budget4update = Budget.where(date: dateFrom..dateTo)

    # 費目毎に予算レコードを作成/更新
    ExpenseItem.where(expense_type: 'o').order(sort: :asc).each do |item|
      # 費目で該当するレコードを取得
      b4u = budget4update.find_by_expense_item_id(item.id)

      # 入力された金額
      amount = params["amount_" + item.id.to_s]

      p b4u
      # 削除処理
      if amount.blank?
        b4u.destroy unless b4u.blank?

      # 保存処理
      else
        # 既存行が無い場合は新規作成
        if b4u.blank?
          b4u = Budget.new
        end

        b4u.date = params["date"]
        b4u.expense_item_id = item.id
        b4u.amount = amount

        b4u.save
      end
    end
  end
end
