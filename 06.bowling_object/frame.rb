# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @shots = [first_shot, second_shot, third_shot].compact.map { |shot| Shot.new(shot) }
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
