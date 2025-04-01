#!/usr/bin/env ruby

require 'date'
require 'optparse'

options = ARGV.getopts("m:y:")
specified_month = (options["m"] || Date.today.month).to_i
specified_year = (options["y"] || Date.today.year).to_i

def show_calendar(specified_year, specified_month)
  first_date = Date.new(specified_year, specified_month, 1)
  last_date = Date.new(specified_year, specified_month, -1)

  puts "#{first_date.strftime('%B')} #{specified_year}".center(23)
  puts " Su Mo Tu We Th Fr Sa"
  print "   " * first_date.wday

  (first_date..last_date).each do |date|
    if date.day <= 9
      print "  #{date.day}"
    else
      print " #{date.day}"
    end
    puts "\n" if date.saturday?
  end
end

show_calendar(specified_year, specified_month)
