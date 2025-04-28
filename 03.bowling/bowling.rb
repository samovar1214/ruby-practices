#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  shots <<  if s == 'X'
              10
            else
              s.to_i
            end
end

frames = []
one_frame = []
shots.each do |s|
  one_frame << s
  if frames.count < 10
    if one_frame.count == 2 || s == 10
      frames << one_frame.clone
      one_frame.clear
    end
  else
    frames[-1] << s
  end
end

point = 0
(0..7).each do |n|
  two_frames = frames[n + 1] + frames[n + 2]
  point +=
    if frames[n][0] == 10
      10 + two_frames[0] + two_frames[1]
    elsif frames[n].sum == 10
      10 + frames[n + 1][0]
    else
      frames[n].sum
    end
end

point +=
  if frames[8][0] == 10
    10 + (frames[9][0] + frames[9][1])
  elsif frames[8].sum == 10
    10 + frames[9][0]
  else
    frames[8].sum
  end

point += frames[9].sum
puts point
