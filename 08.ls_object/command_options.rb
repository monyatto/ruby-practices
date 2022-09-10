# frozen_string_literal: true

require 'optparse'

class CommandOptions
  attr_reader :option, :path

  def initialize
    @option = []
    opt = OptionParser.new
    opt.on('-a') { option << '-a' }
    opt.on('-r') { option << '-r' }
    opt.on('-l') { option << '-l' }
    @path = opt.parse!(ARGV)
  end

  def all_option?
    option.include?('-a')
  end

  def reverse_option?
    option.include?('-r')
  end

  def file_info?
    option.include?('-l')
  end
end
