# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    shots = marks.map { |mark| Shot.new(mark) }
    @frames = build_frames(shots)
  end

  def score
    @frames.sum { |frame| frame.score(@frames) }
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
end
