# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :index, :shots

  def initialize(index, shots)
    @index = index
    @shots = shots
  end

  def score(frames)
    base_score = shots.sum(&:score)
    return base_score if index == 9

    if strike?
      base_score + strike_bonus(frames)
    elsif spare?
      base_score + spare_bonus(frames)
    else
      base_score
    end
  end

  private

  def strike?
    shots[0].score == 10
  end

  def spare?
    !strike? && shots[0..1].sum(&:score) == 10
  end

  def strike_bonus(frames)
    two_shots = frames[index + 1].shots + (frames[index + 2]&.shots || [])
    two_shots[0..1].sum(&:score)
  end

  def spare_bonus(frames)
    frames[index + 1].shots[0].score
  end
end
