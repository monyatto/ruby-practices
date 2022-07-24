# frozen_string_literal: true

require_relative 'game'

puts Game.new(ARGV[0]).score unless ARGV[0].nil?
