#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def layout_by_columns(filenames, column_count)
  row_count = filenames.length.ceildiv(column_count)
  rows = Array.new(row_count) { [] }

  filenames.each_with_index do |filename, index|
    row_index = index % row_count
    rows[row_index] << filename
  end

  rows
end

def print_rows(rows)
  max_filename_length = rows.flatten.map(&:length).max

  rows.each do |row|
    row.each do |filename|
      printf("%-#{max_filename_length}s\t", filename)
    end
    puts
  end
end

options = ARGV.getopts('a')

filenames = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort

column_count = 3
rows = layout_by_columns(filenames, column_count)
print_rows(rows)
