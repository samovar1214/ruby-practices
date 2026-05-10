# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    shots = marks.map { |mark| Shot.new(mark) }
    @frames = build_frames(shots)
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

    total_score + @frames[9].score
  end

  private

  def build_frames(shots)
    shot_index = 0

    Array.new(10) do |index|
      if index == 9
        Frame.new(index, shots[shot_index..])
      else
        shots_count = shots[shot_index].strike? ? 1 : 2
        Frame.new(index, shots[shot_index, shots_count]).tap do
          shot_index += shots_count
        end
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
