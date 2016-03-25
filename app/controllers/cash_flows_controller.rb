class CashFlowsController < ApplicationController

  ##############################################################
  # 登録処理（Ajaxリクエスト）
  ##############################################################
  def create
    # 処理分岐
    if params[:edit_btn]
      edit
      return
    elsif params[:edit_cancel_btn]
      editCancel
      return
    end

    ####################################
    # キャッシュフローを新規作成
    ####################################
    @cashFlow = CashFlow.new(cashflow_params)

    ####################################
    # 口座情報を更新
    ####################################
    updateAccount(1)

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
    updateAccount(-1)

    ####################################
    # キャッシュフローを削除
    ####################################
    @cashFlow.destroy

    render
  end
 
  ##############################################################
  # 編集開始（Ajaxリクエスト）
  ##############################################################
  def editStart
    ####################################
    # 編集対象のキャッシュフローを取得
    ####################################
    @cashFlow = CashFlow.find(params[:id])

    render
  end
 
  ##############################################################
  # 編集処理（Ajaxリクエスト）
  ##############################################################
  def edit
    ####################################
    # 更新対象のキャッシュフローを取得
    ####################################
    @cashFlow = CashFlow.find(cashflow_params[:id])

    ####################################
    # 口座情報を更新（更新前の情報で削除）
    ####################################
    updateAccount(-1)

    ####################################
    # キャッシュフローを更新
    ####################################
    #cashflow_params.flow_type = @cashFlow.flow_type

    if @cashFlow.update(cashflow_params)
      # edit.js.erb
      render "edit"
    end

    ####################################
    # 口座情報を更新（更新後の情報で登録）
    ####################################
    updateAccount(1)
  end

  ##############################################################
  # 口座情報を更新
  ##############################################################
  def updateAccount(mode)
    account = Account.find(@cashFlow.account_id)

    # 収入
    if @cashFlow.flow_type == "i"
      account.update(current_amount: account.current_amount + @cashFlow.amount * mode)

    # 支出
    elsif @cashFlow.flow_type == "o"
      account.update(current_amount: account.current_amount - @cashFlow.amount * mode)

    # 移動
    elsif @cashFlow.flow_type == "m"
      account.update(current_amount: account.current_amount - @cashFlow.amount * mode)

      # 移動先も更新
      moveToAccount = Account.find(@cashFlow.move_to)
      moveToAccount.update(current_amount: moveToAccount.current_amount + @cashFlow.amount * mode)
    end
  end

  ##############################################################
  # 編集終了（Ajaxリクエスト）
  ##############################################################
  def editCancel
    # editCancel.js.erb
    render "editCancel"
  end

  private
    def cashflow_params
      params.require(:cash_flow).permit(:id, :date, :account_id, :flow_type, :amount, :move_to, :expense_item_id, :memo, :credit_card)
    end
end
