/***************************************
 * カレンダー選択プラグイン
 ***************************************/
(function($) {
 
  /**
   * カレンダー選択（年月日）を使用する準備をします。
   * @param options 初期表示時の年月
   *          .year  年
   *          .month 月(0〜)
   *          .date  日(1〜)
   */
  $.fn.readyCalendarYMD = function(options) {
    // 引数を設定する
    var today = new Date();
    var defaults = {
      year  : today.getFullYear(),
      month : today.getMonth(),
      date  : 1
    };
    var setting = $.extend(defaults, options);

    // onClick時のイベント登録
    var cal = new Date(setting.year, setting.month, setting.date);
    var elements = this;
    elements.each(function(i, elem) {
      $(elem).click(function(event) { openCalendar("0", cal, event); });
    });

    // メソッドチェーン対応(thisを返す)
    return(this);
  };

  /**
   * カレンダー選択（年月）を使用する準備をします。
   * @param options 初期表示時の年月
   *          .year  年
   *          .month 月(0〜)
   */
  $.fn.readyCalendarYM = function(options) {
    // 引数を設定する
    var today = new Date();
    var defaults = {
      year  : today.getFullYear(),
      month : today.getMonth()
    };
    var setting = $.extend(defaults, options);

    // onClick時のイベント登録
    var cal = new Date(setting.year, setting.month, 1);
    var elements = this;
    elements.each(function(i, elem) {
      $(elem).click(function(event) { openCalendar("1", cal, event); });
    });

    // メソッドチェーン対応(thisを返す)
    return(this);
  };

  // ---------------------------------------------

  /**
   * カレンダーを作成して表示します。
   * @param type "0":年月日選択, "1":年月選択
   * @param cal 初期表示時の年月日
   * @param event クリックイベント
   */
  function openCalendar(type, cal, event) {
    // カレンダーを作成
    var calendar = createCalendar(type, cal);

    // 表示
    $("body").append(calendar);
    calendar.fadeIn("slow");

    // 閉じるイベントを登録
    $(document).unbind().click(function(e) {
      if (!$.contains(calendar[0], e.target)) {
        calendar.fadeOut("slow", function() { calendar.remove(); });
      }
    });

    // 連続してイベントが発生するのを抑制
    event.stopPropagation();
  }

  /**
   * カレンダーを作成します。
   * @param type "0":年月日選択, "1":年月選択
   * @param cal 初期表示時の年月日
   */
  function createCalendar(type, cal) {
    var calendar = $("<div>", { id:"calPanel", style:"display:none;" });

    // ヘッダー
    var WEEKDAY = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    for (var i = 0; i < WEEKDAY.length; i++) {
      var html = "<div class='cal-box cal-header cal-header-selector'>"
               + "  <span class='weekday'" + i + ">" + WEEKDAY[i] + "</span>"
               + "</div>";
      calendar.append(html);
    }
    calendar.append("<div style='clear:both;'></div>");

    // 日付
    var year = cal.getFullYear();
    var month = cal.getMonth();
    var date = 1;
    var today = new Date();
    var firstDate = new Date(year, month, 1);
    var lastDate = new Date(year, month + 1, 0);
    for (var w = 0; w < 6; w++) {
      for (var d = 0; d < 7; d++) {
        if ((w === 0 && firstDate.getDay() > d) || (date > lastDate.getDate())) {
          // 月初まで or 月末以降
          calendar.append($("<div>", {class:"cal-box cal-body cal-body-selector"}));

        } else {
          var addClass = (year == today.getFullYear() && month == today.getMonth() && date == today.getDate() ? "cal-today" : "");
          var calDate = $("<div>", {class:"cal-box cal-body cal-body-selector " + addClass});

          // 日付
          var dateLink = $("<span>", {class:"date" + d}).append(
                            $("<a>", {href:"?year=" + year + "&month=" + month + "&date=" + date}).append(date));

          calendar.append(calDate.append(dateLink));
          date++;
        }
      }
    }
    calendar.append("<div style='clear:both;'></div>");

    return calendar;
  }

})(jQuery);

  /**
   * カレンダー(年月)を作成して返します。
   */
  //createCalendarYM: function(year) {
//  var page = <?= page ?>;
//  var html = '<div id="calPanel">';
//  
//  // 年選択
//  html += '<div id="year-sel-box">';
//  for (var i = 2014; i < 2030; i++) {
//    html += '<div class="year-sel ';
//    if (i == year) {
//      html += 'selected-year'
//    }
//    html += '" onclick="selYear(' + i + ', this)">' + i + '年</div>';
//  }
//  html += '</div>';
//  html += '<input type="hidden" id="year-selected" value="' + year + '">';
//
//  // 月選択
//  html += '<div id="month-sel-box">';
//  for (var i = 0; i < 12; i++) {
//    if (i == 6) {
//      html += '<div style="clear:both;" />';
//    }
//    html += '<div class="month-sel">';
//    html += '<a href="?page=' + page + '&year=' + year + '&month=' + i + '" class="swm">' + (i + 1) + '月</a>';
//    html += '</div>';
//  }
//  html += '</div>';
//
//  html += '</div>';
//  return html;
//  }
//};



//function selYear(year, elem) {
//  $('#year-selected').val(year);
//
//  $('.selected-year').removeClass('selected-year');
//  $(elem).addClass('selected-year');
//
//  $('.month-sel > a').each(function() {
//    var url = $(this).attr('href');
//    $(this).attr('href', url.replace(/year=.*&/ ,"year=" + year + "&"));
//  });
//}
//
//// センタリングする
//function centeringCalendar(){
//   // 画面(ウィンドウ)の幅を取得
//   var w = $(window).width();
//
//   // カレンダーの幅を取得
//   //var cw = $("#calPanel").outerWidth({margin:true});
//   var cw = 960;
//   
//   //センタリングを実行する
//   $("#calPanel").css({"left": ((w - cw)/2) + "px"});
//}
//
//

