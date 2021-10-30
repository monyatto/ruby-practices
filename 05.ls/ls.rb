# frozen_string_literal: true

require 'optparse'
opt = OptionParser.new
opt.on('-a') do
  option = File::FNM_DOTMATCH unless ARGV[-1].nil?
  opt.parse(ARGV)
end

if !ARGV[-1].nil?
  if Dir.exist?(ARGV[-1])
    files_path = Dir.glob("#{ARGV[-1]}/*", option)
    files = files_path.map { |f| File.basename(f) }
  end
else
  files_path = Dir.glob('*')
  files = files_path.map { |f| File.basename(f), option}
end

def print_files
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

puts print_files
