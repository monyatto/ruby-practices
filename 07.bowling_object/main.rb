# frozen_string_literal: true

require_relative 'game'

if ARGV[0].nil?
  puts '引数にスコアを渡してください'
else
  puts Game.new(ARGV[0]).score
end
