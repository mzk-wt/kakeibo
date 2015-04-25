class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ####################################################
  # アクション前の処理
  ####################################################
  # 認証チェック
  before_action :authenticate_user_check!

  ####################################################
  # リクエストパラメータから年月日を算出する
  ####################################################
  def getCalendar()

    # リクエストパラメータで指定された年月日を設定
    # 指定がなかった場合、現在の年月日を設定
    year  = params[:year].blank?  ? Date.today.year  : params[:year]
    month = params[:month].blank? ? Date.today.month : params[:month]
    day   = params[:day].blank?   ? Date.today.day   : params[:day]

    # 日付オブジェクトを作成 
    date = Date.new(year.to_i, month.to_i, day.to_i)

    # 日付の計算
    if params[:calc_date].blank? then
      # 計算なし
      @cal = date

    elsif params[:calc_date] == "nd" then
      # 翌日
      @cal = date + 1
      
    elsif params[:calc_date] == "pd" then
      # 前日
      @cal = date - 1

    elsif params[:calc_date] == "nm" then
      # 翌月
      @cal = date >> 1

    elsif params[:calc_date] == "pm" then
      # 前月
      @cal = date << 1
    end
  end

private

  ####################################################
  # 認証チェック
  ####################################################
  def authenticate_user_check!
    exceptPath = %w{/users /users/sign_in /users/sign_out}
    pass = params["p"]

    p request.path_info
    p pass

    # 認証がまだの場合はログイン画面へ遷移する
    unless user_signed_in? or exceptPath.include?(request.path_info) or (request.path_info == "/users/sign_up" and pass == "0728100607220425")
      redirect_to('/users/sign_in')
    end
  end

end
