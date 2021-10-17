# frozen_string_literal: true

def ls
  files = Dir.glob("*")
  word_count = files.max_by(&:length).length + 4
  column_count = 8
  gyou = (files.size / column_count.to_f).ceil

  gyou.times do |index|
    column_count.times do |count|
      puts "" if count == (column_count - 1)
      now_column = index + gyou * count
      print files[now_column].ljust(word_count) if !files[now_column].nil?
    end
  end
  puts ""
end

  puts ls
