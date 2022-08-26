# frozen_string_literal: true

require 'pathname'
require 'etc'

class FileInfo
  attr_reader :segment, :total, :filetype, :permission, :hardlink, :owner, :group, :filesize, :timestamp

  FTYPE = { 'fifo' => 'p', 'characterSpecial' => 'c', 'directory' => 'd', 'blockSpecial' => 'b', 'file' => '-', 'link' => 'l', 'socket' => 's' }.freeze

  def initialize(segment, argv)
    @segment = segment
    @total = examine_total
    @filetype = examine_filetype
    @permission = examine_permission
    @hardlink = examine_hardlink
    @owner = examine_owner
    @group = examine_group
    @filesize = examine_filesize
    @timestamp = examine_timestamp
    @argv = argv
  end

  private

  def examine_total
    filestat.blocks
  end

  def examine_filetype
    FTYPE[filestat.ftype]
  end

  def filestat
    File::Stat.new(path.relative_path_from(base).to_s)
  end

  def path
    Pathname.new(File.expand_path(@argv.to_s) << '/' << @segment)
  end

  def base
    Pathname.new(Dir.pwd)
  end

  def examine_permission
    (3..5).map { |letters| chars_permission(unshift_filestat, letters) }
  end

  def chars_permission(unshift_filestat, letters)
    permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
    permission[unshift_filestat[letters]]
  end

  def unshift_filestat
    chars_filestat.size < 6 ? chars_filestat.unshift(0) : chars_filestat
  end

  def chars_filestat
    filestat.mode.to_s(8).chars
  end

  def examine_hardlink
    filestat.nlink.to_s
  end

  def examine_owner
    Etc.getpwuid(File.stat(path).uid).name.to_s
  end

  def examine_group
    Etc.getgrgid(File.stat(path).gid).name.to_s
  end

  def examine_filesize
    filestat.size.to_s
  end

  def examine_timestamp
    filestat.mtime.strftime(' %b %e %H:%M ')
  end
end
