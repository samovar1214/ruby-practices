# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @shots = [first_mark, second_mark, third_mark].compact.map { |mark| Shot.new(mark) }
  end

  def score
    shots.map(&:score).sum
  end

  def strike?
    shots[0].score == 10
  end

  def spare?
    shots[0].score + shots[1].score == 10 unless strike?
  end
end
