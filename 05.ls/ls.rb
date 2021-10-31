# frozen_string_literal: true

require 'optparse'

filse_option = nil

OptionParser.new do |opt|
  opt.on('-a') { filse_option = '-a' }
  opt.parse!(ARGV)
end

files =
  if filse_option == '-a'
    Dir.glob('*', File::FNM_DOTMATCH, base: ARGV[0].to_s)
  else
    Dir.glob('*', base: ARGV[0].to_s)
  end

def print_files(files)
  max_word_count = files.max_by(&:length).length + 7
  column = 3
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

puts print_files(files)
