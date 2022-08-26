# frozen_string_literal: true

require_relative 'long_option'
require_relative 'ls_command'
require 'pathname'
require 'etc'

class FormatLongOption
  def initialize(segments, file_informations)
    @file_informations = file_informations
    @segments = segments
  end

  def format
    puts total
    @file_informations.map do |file_information|
      str = +''
      str << file_information.filetype
      str << file_information.permission.join
      str << file_information.hardlink.rjust(max_length(nlinks, 2))
      str << file_information.owner.rjust(max_length(owners, 1))
      str << file_information.group.rjust(max_length(groups, 2))
      str << file_information.filesize.rjust(max_length(filesizes, 2))
      str << file_information.timestamp
      str << file_information.segment
    end
  end

  private

  def total
    "total #{@segments.map { |segment| filestat(segment).blocks }.sum}"
  end

  def max_length(files, num)
    files.max_by(&:length).length + num
  end

  def nlinks
    @segments.map { |segment| filestat(segment).nlink.to_s }
  end

  def filestat(segment)
    File::Stat.new(path(segment).relative_path_from(base).to_s)
  end

  def base
    Pathname.new(File.expand_path(__dir__))
  end

  def path(segment)
    Pathname.new(File.expand_path(ARGV[0].to_s) << '/' << segment)
  end

  def owners
    @segments.map do |segment|
      Etc.getpwuid(File.stat(path(segment)).uid).name.to_s
    end
  end

  def groups
    @segments.map do |segment|
      Etc.getgrgid(File.stat(path(segment)).gid).name.to_s
    end
  end

  def filesizes
    @segments.map do |segment|
      filestat(segment).size.to_s
    end
  end
end
