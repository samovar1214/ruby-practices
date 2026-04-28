# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @frames = build_frames(marks)
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

  def build_frames(marks)
    mark_index = 0

    Array.new(10) do |frame_index|
      if frame_index == 9
        Frame.new(*marks[mark_index..])
      else
        marks_count = Shot.new(marks[mark_index]).strike? ? 1 : 2
        frame = Frame.new(*marks[mark_index, marks_count])
        mark_index += marks_count
        frame
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
