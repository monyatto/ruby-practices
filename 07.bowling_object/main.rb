# frozen_string_literal: true

require_relative 'game'

if ARGV[0]
  puts Game.new(ARGV[0]).score
else
  puts '引数にスコアを渡してください'
end
