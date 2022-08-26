# frozen_string_literal: true

require_relative 'argument'
require_relative 'long_option_formatter'
require_relative 'long_option'
require_relative 'no_option'

class LsCommand
  def initialize(argument)
    @argument = argument
    @segments = segments
  end

  def list_segment
    if @argument.long_option?
      puts FormatLongOption.new(segments, segments.map { |segment| LongOption.new(segment) }).format
    else
      NoOption.new(segments).format
    end
  end

  private

  def segments
    sort_files(set_files)
  end

  def set_files
    @argument.all_option? ? Dir.glob('*', File::FNM_DOTMATCH, base: ARGV[0].to_s) : Dir.glob('*', base: ARGV[0].to_s)
  end

  def sort_files(set_files)
    @argument.reverse_option? ? set_files.reverse : set_files
  end
end
