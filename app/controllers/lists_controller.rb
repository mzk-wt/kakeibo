class ListsController < ApplicationController

  def monthlyList
    # 表示対象の年月
    @cal = getCalendar()

    # 指定月の範囲
    dateFrom = @cal.beginning_of_month
    dateTo = @cal.end_of_month

    # 収入一覧
    @cashFlowI = CashFlow.where(date: dateFrom..dateTo, flow_type: 'i').order(date: :asc)
    # 支出一覧
    @cashFlowO = CashFlow.where(date: dateFrom..dateTo, flow_type: 'o').order(date: :asc)
    # 移動一覧
    @cashFlowM = CashFlow.where(date: dateFrom..dateTo, flow_type: 'm').order(date: :asc)

  end

  def dailyList
    # 表示対象の年月日
    @cal = getCalendar()

    # キャッシュフロー
    @cashFlow = CashFlow.new
    
    # 選択肢
    # -----------------
    # 口座
    @accounts = Account.all.order(id: :asc).map { |t| [t.name, t.id] }
    # フロー種別
    @flowTypes = [['支出', 'o'], ['収入', 'i'], ['移動', 'm']]
    # 費目
    @expItemsI = [["", ""]].concat(ExpenseItem.where(expense_type: 'i').order(id: :asc).map { |t| [t.name, t.id] })
    @expItemsO = [["", ""]].concat(ExpenseItem.where(expense_type: 'o').order(id: :asc).map { |t| [t.name, t.id] })

    # 収入一覧
    @cashFlowI = CashFlow.where(date: @cal, flow_type: 'i')
    # 支出一覧
    @cashFlowO = CashFlow.where(date: @cal, flow_type: 'o')
    # 移動一覧
    @cashFlowM = CashFlow.where(date: @cal, flow_type: 'm')
  end
end
