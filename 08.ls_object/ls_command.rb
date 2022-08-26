# frozen_string_literal: true

require_relative 'command_options'
require_relative 'long_option_formatter'
require_relative 'file_info'
require_relative 'no_option_formatter'

class LsCommand
  def initialize(command_options)
    @command_options = command_options
    @segments = segments
  end

  def list_segment
    if @command_options.file_info?
      puts FormatLongOption.new(segments, segments.map { |segment| LongOption.new(segment) }).format
    else
      NoOptionFormatter.new(segments).format
    end
  end

  private

  def segments
    sort_files(set_files)
  end

  def set_files
    @command_options.all_option? ? Dir.glob('*', File::FNM_DOTMATCH, base: ARGV[0].to_s) : Dir.glob('*', base: ARGV[0].to_s)
  end

  def sort_files(set_files)
    @command_options.reverse_option? ? set_files.reverse : set_files
  end
end
