# frozen_string_literal: true

class NoOptionFormatter
  COLUMN = 3

  def initialize(segments)
    @segments = segments
  end

  def format
    row.times do |row_num|
      COLUMN.times do |column_num|
        print @segments[print_num(row, row_num, column_num)].ljust(max_length(@segments, 3)) unless @segments[print_num(row, row_num, column_num)].nil?
        puts '' if column_num == (COLUMN - 1)
      end
    end
  end

  private

  def row
    (@segments.size / COLUMN.to_f).ceil
  end

  def print_num(row, row_num, column_num)
    row_num + row * column_num
  end

  def max_length(files, num)
    files.max_by(&:length).length + num
  end
end
