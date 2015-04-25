class CashFlowsController < ApplicationController

  ##############################################################
  # 登録処理（Ajaxリクエスト）
  ##############################################################
  def create
    ####################################
    # キャッシュフローを新規作成
    ####################################
    @cashFlow = CashFlow.new(cashflow_params)

    ####################################
    # 口座情報を更新
    ####################################
    account = Account.find(@cashFlow.account_id)

    # 収入
    if @cashFlow.flow_type == "i"
      account.update(current_amount: account.current_amount + @cashFlow.amount)

    # 支出
    elsif @cashFlow.flow_type == "o"
      account.update(current_amount: account.current_amount - @cashFlow.amount)

    # 移動
    elsif @cashFlow.flow_type == "m"
      account.update(current_amount: account.current_amount - @cashFlow.amount)

      # 移動先も更新
      moveToAccount = Account.find(@cashFlow.move_to)
      moveToAccount.update(current_amount: moveToAccount.current_amount + @cashFlow.amount)
    end

    ####################################
    # キャッシュフローを保存
    ####################################
    if @cashFlow.save
      render
    end
  end

  ##############################################################
  # 削除処理（Ajaxリクエスト）
  ##############################################################
  def destroy
    ####################################
    # 削除対象のキャッシュフローを取得
    ####################################
    @cashFlow = CashFlow.find(params[:id])

    ####################################
    # 口座情報を更新
    ####################################
    account = Account.find(@cashFlow.account_id)

    # 収入
    if @cashFlow.flow_type == "i"
      account.update(current_amount: account.current_amount - @cashFlow.amount)

    # 支出
    elsif @cashFlow.flow_type == "o"
      account.update(current_amount: account.current_amount + @cashFlow.amount)

    # 移動
    elsif @cashFlow.flow_type == "m"
      account.update(current_amount: account.current_amount + @cashFlow.amount)

      # 移動先も更新
      moveToAccount = Account.find(@cashFlow.move_to)
      moveToAccount.update(current_amount: moveToAccount.current_amount - @cashFlow.amount)
    end

    ####################################
    # キャッシュフローを削除
    ####################################
    @cashFlow.destroy

    render
  end

  private
    def cashflow_params
      params.require(:cash_flow).permit(:date, :account_id, :flow_type, :amount, :move_to, :expense_item_id, :memo, :credit_card)
    end
end
