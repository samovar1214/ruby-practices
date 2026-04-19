#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/game'

pins = ARGV[0].split(',')
game = Game.new(pins)
puts game.score
