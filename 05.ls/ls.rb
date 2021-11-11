# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'etc'

files_option = []
opt = OptionParser.new
opt.on('-a') { files_option << '-a' }
opt.on('-r') { files_option << '-r' }
opt.on('-l') { files_option << '-l' }
opt.parse!(ARGV)

files =
  if files_option.include?('-a')
    Dir.glob('*', File::FNM_DOTMATCH, base: ARGV[0].to_s)
  else
    Dir.glob('*', base: ARGV[0].to_s)
  end
files.reverse! if files_option.include?('-r')

def print_file(files, files_option)
  if files_option.include?('-l')
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

def permission_decision(file_stat_chars, letters)
  permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
  permission[file_stat_chars[letters]]
end

def ftype_decision(file_stat)
  ftype = { 'fifo' => 'p', 'characterSpecial' => 'c', 'directory' => 'd', 'blockSpecial' => 'b', 'file' => '-', 'link' => 'l', 'socket' => 's' }
  ftype[file_stat.ftype]
end

def nlink_max_count_decision(files)
  nlink = []
  files.each do |file|
    base = Pathname.new(File.expand_path(__dir__))
    path = Pathname.new(File.expand_path(ARGV[0].to_s) << '/' << file)
    file_stat = File::Stat.new(path.relative_path_from(base).to_s)
    nlink << file_stat.nlink.to_s
  end
  nlink
end

def size_max_count_decision(files)
  size = []
  files.each do |file|
    base = Pathname.new(File.expand_path(__dir__))
    path = Pathname.new(File.expand_path(ARGV[0].to_s) << '/' << file)
    file_stat = File::Stat.new(path.relative_path_from(base).to_s)
    size << file_stat.size.to_s
  end
  size
end

def l_option(files)
  nlink = nlink_max_count_decision(files)
  size = size_max_count_decision(files)
  nlink_max_count = nlink.max_by(&:length).length + 1
  size_max_count = size.max_by(&:length).length + 1
  files.each do |file|
    base = Pathname.new(File.expand_path(__dir__))
    path = Pathname.new(File.expand_path(ARGV[0].to_s) << '/' << file)
    file_stat = File::Stat.new(path.relative_path_from(base).to_s)
    l_option = []
    l_option << ftype_decision(file_stat)
    file_stat_chars = file_stat.mode.to_s(8).chars
    file_stat_chars.unshift 0 if file_stat_chars.size < 6
    l_option.concat((3..5).map { |letters| permission_decision(file_stat_chars, letters) })
    l_option << file_stat.nlink.to_s.rjust(nlink_max_count) << ' ' << Etc.getpwuid(File.stat(path).uid).name.to_s << '  ' <<
      Etc.getgrgid(File.stat(path).gid).name.to_s << file_stat.size.to_s.rjust(size_max_count) << file_stat.mtime.strftime(' %b %e %H:%M ') << file
    puts l_option.join
  end
end

print_file(files, files_option)
