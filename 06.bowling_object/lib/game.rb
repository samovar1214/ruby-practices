# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(pins)
    @frames = build_frames(pins)
  end

  def score
    total_score = 0

    @frames[0..8].each_with_index do |frame, index|
      total_score += frame.score
      if frame.strike?
        total_score += strike_bonus(index)
      elsif frame.spare?
        total_score += spare_bonus(index)
      end
    end

    total_score + frames[9].score
  end

  private

  def build_frames(pins)
    (1..10).each_with_object([]) do |index, frames|
      if index < 10
        if pins[0] == 'X'
          frames << Frame.new(pins.shift)
        else
          first_pin, second_pin = pins.shift(2)
          frames << Frame.new(first_pin, second_pin)
        end
      else
        first_pin, second_pin, third_pin = pins
        frames << Frame.new(first_pin, second_pin, third_pin)
      end
    end
  end

  def strike_bonus(index)
    two_shots = @frames[index + 1].shots + (@frames[index + 2]&.shots || [])
    two_shots[0..1].sum(&:score)
  end

  def spare_bonus(index)
    @frames[index + 1].shots[0].score
  end
end
