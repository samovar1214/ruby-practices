#!/usr/bin/env ruby
# frozen_string_literal: true

shots = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }

one_frame = []
frames = shots.each_with_object([]) do |shot, frames|
  one_frame << shot
  if frames.count < 10
    if one_frame.count == 2 || shot == 10
      frames << one_frame.clone
      one_frame.clear
    end
  else
    frames[-1] << shot
  end
end

point = (0..8).each.sum do |index|
  bonus = if frames[index][0] == 10
            frames[index + 1] ||= []
            frames[index + 2] ||= []
            two_frames = frames[index + 1] + frames[index + 2]
            two_frames[0..1].sum
          elsif frames[index].sum == 10
            frames[index + 1][0]
          else
            0
          end
  frames[index].sum + bonus
end

point += frames[9].sum
puts point
