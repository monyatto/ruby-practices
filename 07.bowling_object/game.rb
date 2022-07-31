# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(mark)
    marks = mark.split(',')

    figures = []
    figures = convert_marks_into_figures(marks, figures)

    scorings = []
    scorings = convert_figures_into_scoring(figures, scorings)

    @frames = []
    convert_scoring_into_frames(marks, scorings)
  end

  def score
    @frames.sum do |f|
      f.score
    end
  end

  private

  def convert_marks_into_figures(marks, figures)
    marks.each do |m|
      if m == 'X'
        figures.push(10, 0)
      else
        figures.push(m.to_i)
      end
    end
    figures
  end

  def convert_figures_into_scoring(figures, scorings)
    9.times do
      scorings <<
        if figures[0] == 10
          :strike
        elsif figures[0] + figures[1] == 10
          :spare
        else
          :none
        end
      figures = figures.pop(figures.length - 2)
    end
    scorings
  end

  def convert_scoring_into_frames(marks, scorings)
    scorings.each_with_index do |scoring, i|
      case scoring
      when :strike
        @frames[i] = Frame.new(marks[0], marks[1], marks[2])
      when :spare
        @frames[i] = Frame.new(marks[0], marks[1], marks[2])
      when :none
        @frames[i] = Frame.new(marks[0], marks[1])
      end
      marks = remove_marks(marks, scoring)
    end
    @frames[9] = Frame.new(marks[0], marks[1], marks[2])
  end

  def remove_marks(marks, scoring)
    if scoring == :strike
      marks.pop(marks.length - 1)
    else
      marks.pop(marks.length - 2)
    end
  end
end
