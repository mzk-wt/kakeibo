class TopController < ApplicationController

  ####################################################
  # TOPページを表示する
  ####################################################
  def index
    # 表示対象の年月日
    @cal = getCalendar()

    # 指定月の範囲
    dateFrom = @cal.beginning_of_month
    dateTo = @cal.end_of_month

    # 指定月が今月かどうか
    yearMonth = @cal.strftime("%Y%m")
    yearMonthToday = Date.today.strftime("%Y%m")
    @thisMonth = (yearMonth == yearMonthToday)

    # 残りの日数（前月以前の場合は０、翌月以降は全日）
    if (@thisMonth)
      # 今月
      @leftDays = @cal.end_of_month.day - Date.today.day + 1

    elsif (yearMonth.to_i < yearMonthToday.to_i) 
      # 前月以前
      @leftDays = "0"

    else
      # 翌月以降
      @leftDays = @cal.end_of_month.day

    end

    # 口座情報
    @account = Account.all.order(id: :asc)

    # 予算情報
    @budgetAll = Budget.where(date: dateFrom..dateTo)
    @budgetOfLiving = Budget.where(date: dateFrom..dateTo, expense_items: {category: '0'})

    # 支出情報
    @expenseAll = CashFlow.where(date: dateFrom..dateTo, flow_type: 'o').order(date: :desc)
    @expenseOfLiving = CashFlow.where(date: dateFrom..dateTo, flow_type: 'o', expense_items: {category: '0'}).order(date: :desc)

    # 収入情報
    @incomeAll = CashFlow.where(date: dateFrom..dateTo, flow_type: 'i').order(date: :desc)

    # 予算/支出/残高
    @sumBudgetAll = @budgetAll.sum(:amount)                       # 予算合計（全部）
    @sumExpenseAll = @expenseAll.sum(:amount)                     # 支出合計（全部）
    @balanceAll = @sumBudgetAll - @sumExpenseAll                  # 残高（全部）
    @sumBudgetOfLiving = @budgetOfLiving.sum(:amount)             # 予算合計（生活費）
    @sumExpenseOfLiving = @expenseOfLiving.sum(:amount)           # 支出合計（生活費）
    @balanceOfLiving = @sumBudgetOfLiving - @sumExpenseOfLiving   # 残高（生活費）
  end

  ####################################################
  # 費目毎の予算残高ページを表示する
  ####################################################
  def budgetBalance
    # 表示対象の年月日
    @cal = getCalendar()

    # 指定月の範囲
    dateFrom = @cal.beginning_of_month
    dateTo = @cal.end_of_month

    # 費目
    @expenseItem = ExpenseItem.where(expense_type: 'o').order(sort: :asc)

    # 予算情報
    budgetAll = Budget.where(date: dateFrom..dateTo)
    @budgetInfo = {}
    @expenseItem.find_each { |et|
      sum = budgetAll.where(expense_item_id: et.id).sum(:amount)
      @budgetInfo[et.id.to_s] = sum
    }

    # 支出情報
    expenseAll = CashFlow.where(date: dateFrom..dateTo, flow_type: 'o')
    @expenseInfo = {}
    @expenseItem.find_each { |et|
      sum = expenseAll.where(expense_item_id: et.id).sum(:amount)
      @expenseInfo[et.id.to_s] = sum
    }

    # 警告情報
    @alertInfo = {}
    @expenseItem.find_each { |et|
      budget = @budgetInfo[et.id.to_s].to_i
      expense = @expenseInfo[et.id.to_s].to_i

      if budget < expense
        @alertInfo[et.id.to_s] = "bb-alert"

      elsif budget != 0 && budget == expense
        @alertInfo[et.id.to_s] = "bb-just"

      elsif budget != 0 && ((expense.to_f / budget.to_f) * 100) > 90
        @alertInfo[et.id.to_s] = "bb-warn"

      else
        @alertInfo[et.id.to_s] = "bb-ok"
      end
    }
  end

end
