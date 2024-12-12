require 'date'

class Calendar
  attr_reader :target_date

  def initialize(year = Date.today.year, month = Date.today.month)
    @target_date = Date.new(year, month, 1)
  end

  def print_calendar
    print_header
    print_days
  end

  private

  # ヘッダー部分を出力（年月と曜日）
  def print_header
    puts @target_date.strftime('%B %Y').center(20)
    puts 'Su Mo Tu We Th Fr Sa'
  end

  # 日付部分を出力
  def print_days
    first_day = @target_date
    last_day = Date.new(@target_date.year, @target_date.month, -1)

    # 空白を出力
    print '   ' * first_day.wday

    # 日付を出力
    (1..last_day.day).each do |day|
      weekday = (first_day.wday + day - 1) % 7
      print format_day(day, weekday)
      puts if weekday == 6 # 土曜日の後に改行
    end
    puts # 最後の改行
  end

  # 日付をフォーマットし、色を付ける
  def format_day(day, weekday)
    # 実際の出力は色付きだが、幅を揃えるために2桁固定
    sprintf('%2s ', colorize_day(day, weekday))
  end

  # 曜日に応じて色を付ける
  def colorize_day(day, weekday)
    case weekday
    when 0 # 日曜日
      "\e[31m#{day.to_s.rjust(2)}\e[0m" # 赤色（右寄せで幅を固定）
    when 6 # 土曜日
      "\e[34m#{day.to_s.rjust(2)}\e[0m" # 青色（右寄せで幅を固定）
    else
      day.to_s.rjust(2) # 通常の文字列も右寄せで幅を固定
    end
  end
end

# 実行部分
def main
  # ユーザーに年月を入力させる
  puts '表示したいカレンダーの年を入力してください（例: 2024）:'
  year = gets.chomp.to_i
  puts '表示したいカレンダーの月を入力してください（1-12）:'
  month = gets.chomp.to_i

  # カレンダーを表示
  if month.between?(1, 12)
    calendar = Calendar.new(year, month)
    calendar.print_calendar
  else
    puts '月は1から12の間で指定してください。'
  end
end

# プログラムを実行
main
