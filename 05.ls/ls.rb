# frozen_string_literal: true

def ls
    files = Dir.glob("*")
    word_count = files.max_by(&:length).length + 1
    column_count = 3
    column = 0
    line_count = 0
    p "column_count: #{column_count}"
    p "files.size: #{files.size}"
    p "files: #{files}"
    p "(files.size.to_f / 2).floor: #{(files.size.to_f / 2).floor}"
    # ここ

       p "A"
       gyou = (files.size / column_count.to_f).ceil

       times_count = gyou * column_count
       # nil_count =  (column_count - retsu ) * gyou - ((files.size / column_count.to_f).floor)
       # times_count = files.size + nil_count

    p "times_count: #{times_count}"
    times_count.to_i.times do
      if column == column_count
        puts "\n"
        column = 0
        line_count += 1
      end
      now_column = line_count + (files.size / column_count.to_f).ceil.to_i * column
      space_count = word_count - files[now_column].to_s.size
      print files[now_column]
      space_count.times { print ' ' }
      print '   '
      column += 1
    end
    puts "\n"
end

  puts ls
