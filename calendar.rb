require 'date'

class Calendar
  attr_reader :target_date

  def initialize(year = Date.today.year, month = Date.today.month)
    @target_date = Date.new(year, month, 1) # 指定された年月の月初日
    @today = Date.today                    # 今日の日付
  end

  def print_calendar
    print_header # 年月と曜日ヘッダーを出力
    print_days   # 日付部分を出力
  end

  private

  # カレンダーのヘッダー部分（年月と曜日）を出力
  def print_header
    # 年月を中央揃えで表示（例: "January 2025"）
    puts @target_date.strftime('%B %Y').center(20)
    # 曜日ヘッダーを固定で出力
    puts 'Su Mo Tu We Th Fr Sa'
  end

  # カレンダーの日付部分を出力
  def print_days
    first_day = @target_date                          # 月初の日付
    last_day = Date.new(@target_date.year, @target_date.month, -1) # 月末の日付

    # 月初の曜日に応じて空白を追加
    print '   ' * first_day.wday

    # 1日から月末日までの日付をループで出力
    (1..last_day.day).each do |day|
      current_date = Date.new(@target_date.year, @target_date.month, day)
      weekday = current_date.wday # 各日の曜日を計算
      print format_day(day, weekday, current_date) # フォーマット済みの日付を出力
      puts if weekday == 6 # 土曜日（週末）の後に改行
    end
    puts # 最後の改行を追加してカレンダーの体裁を整える
  end

  # 日付をフォーマットし、色付けを適用
  def format_day(day, weekday, current_date)
    # 今日の日付は特別な色付け（背景を黄色）
    if current_date == @today
      sprintf('%2s ', "\e[43m#{day.to_s.rjust(2)}\e[0m") # 背景黄色で強調
    else
      # 幅を揃えるため、2桁固定でフォーマットしつつ色付け
      sprintf('%2s ', colorize_day(day, weekday))
    end
  end

  # 曜日に応じて色を付ける
  # 日曜日: 赤色, 土曜日: 青色, 平日: 通常色
  def colorize_day(day, weekday)
    case weekday
    when 0 # 日曜日
      "\e[31m#{day.to_s.rjust(2)}\e[0m" # 赤色（右寄せで幅を固定）
    when 6 # 土曜日
      "\e[34m#{day.to_s.rjust(2)}\e[0m" # 青色（右寄せで幅を固定）
    else
      day.to_s.rjust(2) # 通常色（右寄せで幅を固定）
    end
  end
end

# 実行部分
def main
  # ユーザーに表示する年を入力させる
  puts '表示したいカレンダーの年を入力してください（例: 2024）:'
  year = gets.chomp.to_i # 入力値を整数に変換

  # ユーザーに表示する月を入力させる
  puts '表示したいカレンダーの月を入力してください（1-12）:'
  month = gets.chomp.to_i # 入力値を整数に変換

  # ユーザーが入力した値を基にカレンダーを表示
  if month.between?(1, 12)
    calendar = Calendar.new(year, month) # 指定された年と月でカレンダーを初期化
    calendar.print_calendar              # カレンダーを出力
  else
    # 月が範囲外の場合のエラーメッセージ
    puts '月は1から12の間で指定してください。'
  end
end

# プログラムを実行
main
