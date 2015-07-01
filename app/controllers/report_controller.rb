class ReportController < ApplicationController

  def index
    # ******************************
    # リクエストパラメータ取得
    # ******************************
    # 表示期間
    @calFrom = getCalendarFrom()
    @calTo   = getCalendarTo()

    # ******************************
    # モデル情報取得
    # ******************************
    # 口座
    @account = Account.all.order(sort: :asc)
    # 費目（収入）
    @expenseItemI = ExpenseItem.where(expense_type: "i").order(sort: :asc)
    # 費目（支出）
    @expenseItemO = ExpenseItem.where(expense_type: "o").order(sort: :asc)
    # 収入一覧
    @cashFlowI = CashFlow.where(date: @calFrom..@calTo, flow_type: 'i')
    # 支出一覧
    @cashFlowO = CashFlow.where(date: @calFrom..@calTo, flow_type: 'o')
    # 移動一覧
    @cashFlowM = CashFlow.where(date: @calFrom..@calTo, flow_type: 'm')
    # 口座×費目
    @cashFlowSum = CashFlow.unscoped
                           .where(date: @calFrom..@calTo)
                           .select('sum(amount) AS sum_amount, account_id, expense_item_id, flow_type')
                           .group('account_id, expense_item_id')
    
    # ******************************
    # 口座別収支情報作成
    # ******************************
    @accountInfo = {} 
    @account.each do |account|
      # ------------------------------
      # １口座分の情報を取得
      # ------------------------------
      info = {}

      # 口座名
      info["name"]       = account.name
      # 収入合計
      info["incomeSum"] = @cashFlowI.where(account_id: account.id).sum(:amount)
      # 支出合計
      info["outgoSum"]  = @cashFlowO.where(account_id: account.id).sum(:amount)
      # 合計
      info["total"]      = info["income_sum"].to_i - info["outgo_sum"].to_i

      # ------------------------------
      # １口座分の情報を登録
      # ------------------------------
      @accountInfo[account.id] = info
    end

    # 全口座分の合計
    @accountTotalI = @cashFlowI.sum(:amount) 
    @accountTotalO = @cashFlowO.sum(:amount)
    @accountTotal  = @accountTotalI - @accountTotalO

    # ******************************
    # 収入の部明細情報作成
    # ******************************
    @incomeInfo = {}
    @expenseItemI.each do |item|
      # ------------------------------
      # １項目分の情報を作成
      # ------------------------------
      info = {}

      # 費目名
      info["name"]      = item.name
      # 収入合計
      info["incomeSum"] = @cashFlowI.where(expense_item_id: item.id).sum(:amount)

      # ------------------------------
      # １項目分の情報を登録
      # ------------------------------
      @incomeInfo[item.id] = info
    end
    
    # 合計
    @incomeTotal = @cashFlowI.sum(:amount)
    
    # ******************************
    # 支出の部明細情報作成
    # ******************************
    @outgoInfo = {}
    @expenseItemO.each do |item|
      # ------------------------------
      # １項目分の情報を作成
      # ------------------------------
      info = {}

      # 費目名
      info["name"]     = item.name
      # 支出合計
      info["outgoSum"] = @cashFlowO.where(expense_item_id: item.id).sum(:amount)

      # ------------------------------
      # １項目分の情報を登録
      # ------------------------------
      @outgoInfo[item.id] = info
    end

    # 合計
    @outgoTotal = @cashFlowO.sum(:amount)

    # ******************************
    # 電気料金詳細情報作成
    # ******************************
  end

end
