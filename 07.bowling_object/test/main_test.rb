# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'

class MainTest < Minitest::Test
  def test_spare_in_final_frame
    mark = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    assert_equal 139, Game.new(mark).score
  end

  def test_three_strikes_in_final_frame
    mark = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    assert_equal 164, Game.new(mark).score
  end

  def test_spare_of_zero_and_ten
    mark = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    assert_equal 107, Game.new(mark).score
  end

  def test_first_strike_in_final_frame
    mark = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    assert_equal 134, Game.new(mark).score
  end

  def test_perfect_game
    mark = 'X,X,X,X,X,X,X,X,X,X,X,X'
    assert_equal 300, Game.new(mark).score
  end
end
