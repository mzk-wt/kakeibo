class ReportController < ApplicationController

  def index
    # 表示期間
    @calFrom = getCalendarFrom()
    @calTo   = getCalendarTo()

    # 口座
    @account = Account.all.order(sort: :asc)
    # 費目（収入）
    @expenseItemI = ExpenseItem.where(expense_type: "i").order(sort: :asc)
    # 費目（支出）
    @expenseItemO = ExpenseItem.where(expense_type: "o").order(sort: :asc)
    # 収入一覧
    # 収入一覧
    @cashFlowI = CashFlow.where(date: @calFrom..@calTo, flow_type: 'i')
    # 支出一覧
    @cashFlowO = CashFlow.where(date: @calFrom..@calTo, flow_type: 'o')
    # 移動一覧
    @cashFlowM = CashFlow.where(date: @calFrom..@calTo, flow_type: 'm')

    # 口座別収支
    # -----------------
    @accountInfo = {} 
    @account.each do |account|
      info = {}
      # 口座名
      info["name"]       = account.name
      # 収入合計
      info["income_sum"] = @cashFlowI.where(account_id: account.id).sum(:amount)
      # 支出合計
      info["outgo_sum"]  = @cashFlowO.where(account_id: account.id).sum(:amount)
      # 合計
      info["total"]      = info["income_sum"].to_i - info["outgo_sum"].to_i

      @accountInfo[account.id] = info
    end

    # 合計
    @accountTotalI = @cashFlowI.sum(:amount) 
    @accountTotalO = @cashFlowO.sum(:amount)
    @accountTotal  = @accountTotalI - @accountTotalO

    # 収入の部明細
    # -----------------
    @incomeInfo = {}
    @expenseItemI.each do |item|
      info = {}
      # 費目名
      info["name"]       = item.name
      # 収入合計
      info["income_sum"]  = @cashFlowI.where(expense_item_id: item.id).sum(:amount)

      @incomeInfo[item.id] = info
    end
    
    # 合計
    @incomeTotal = @cashFlowI.sum(:amount)

    
    # 支出の部明細
    # -----------------

  end

end
