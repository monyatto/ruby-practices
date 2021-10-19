# frozen_string_literal: true

def ls
  files = Dir.glob('*')
  max_word_count = files.max_by(&:length).length + 4
  column = 8
  line = (files.size / column.to_f).ceil

  line.times do |line_count|
    column.times do |column_count|
      print_file = (line_count + line * column_count)
      print files[print_file].ljust(max_word_count) unless files[print_file].nil?
      puts '' if column_count == (column - 1)
    end
  end
  print ''
end

puts ls
