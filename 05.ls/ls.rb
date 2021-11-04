# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'etc'

files_option = nil

opt = OptionParser.new
opt.on('-l') { files_option = '-l' }
opt.parse!(ARGV)

files = Dir.glob('*', base: ARGV[0].to_s)

def print_file(files, files_option)
  if files_option == '-l'
    l_option(files)
  else
    no_option(files)
  end
end

def no_option(files)
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

def ftype_decision(l_option, file_stat)
  ftype = { 'fifo' => 'p', 'characterSpecial' => 'c', 'directory' => 'd', 'blockSpecial' => 'b', 'file' => '-', 'link' => 'l', 'socket' => 's' }
  l_option << ftype[file_stat.ftype]
end

def permission_decision(l_option, file_stat_chars)
  letters = 2
  3.times do
    letters += 1
    permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
    l_option << permission[file_stat_chars[letters]]
  end
end

def l_option(files)
  files.each do |file|
    base = Pathname.new(File.expand_path(__dir__))
    path = Pathname.new(File.expand_path(ARGV[0].to_s) << '/' << file)
    file_stat = File::Stat.new(path.relative_path_from(base).to_s)
    l_option = []
    ftype_decision(l_option, file_stat)

    file_stat_chars = file_stat.mode.to_s(8).chars
    file_stat_chars.unshift 0 if file_stat_chars.size < 6

    permission_decision(l_option, file_stat_chars)

    l_option <<
      ' ' << file_stat.nlink.to_s << ' ' << Etc.getpwuid(File.stat(path).uid).name.to_s <<
      '  ' << Etc.getgrgid(File.stat(path).gid).name.to_s << '  ' << file_stat.size <<
      file_stat.mtime.strftime(' %b %e %H:%M ') << file
    print l_option.join
    puts ''
  end
end

print_file(files, files_option)
