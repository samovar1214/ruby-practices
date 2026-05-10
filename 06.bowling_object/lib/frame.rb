# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :index, :shots

  def initialize(index, shots)
    @index = index
    @shots = shots
  end

  def score
    shots.sum(&:score)
  end

  def strike?
    shots[0].score == 10
  end

  def spare?
    !strike? && shots[0..1].sum(&:score) == 10
  end
end
