#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

option = []
opt = OptionParser.new
opt.on('-l') { option << '-l' }
opt.parse!(ARGV)

def main(option)
  lines = []
  words = []
  bytesizes = []
  if File.pipe?($stdin)
    print_pipe(option, lines)
  else
    print_argument(option, lines, words, bytesizes)
  end
end

def print_pipe(option, lines)
  $stdin.each_line { |line| lines << line }
  line = lines.join.count("\n")
  word = lines.join.split(/　|\s+/).size
  bytesize = lines.join.bytesize
  if option.include?('-l')
    file_elements = [line]
    file_elements.each { |element| print element.to_s.rjust(8) }
  else
    file_elements = [line, word, bytesize]
    file_elements.each { |element| print element.to_s.rjust(8) }
    print ' '
  end
  puts ''
end

def print_argument(option, lines, words, bytesizes)
  ARGV.each do |file|
    if File.ftype(file) == 'directory'
      puts "wc: #{file}: read: Is a directory"
    else
      lines << line = File.open(file).read.count("\n")
      words << word = File.open(file).read.split(/\s+/).size
      bytesizes << bytesize = File.open(file).read.bytesize
      file_elements = option.include?('-l') ? [line] : [line, word, bytesize]
      file_elements.each { |element| print element.to_s.rjust(8) }
      print " #{file}"
      puts ''
    end
  end
  return unless ARGV.size > 1

  total_elements = []
  total_elements << lines.sum << words.sum << bytesizes.sum
  total_elements.each { |element| print element.to_s.rjust(8) }
  puts ' total'
end

main(option)
