# frozen_string_literal: true

require 'optparse'
require_relative 'directory'
require_relative 'long_formatter'

class ListCommand
  COLUMN_COUNT = 3

  def initialize(argv)
    @options = argv.getopts('arl').transform_keys(&:to_sym)
  end

  def run
    directory = Directory.new('.', all: @options[:a], reverse: @options[:r])
    entries = directory.entries

    @options[:l] ? display_long(directory.total_blocks, entries) : display_columns(entries)
  end

  private

  def display_long(total_blocks, entries)
    puts "total #{total_blocks}"

    formatter = LongFormatter.new(entries)
    puts formatter.format
  end

  def display_columns(entries)
    names = entries.map(&:name)
    rows = layout_by_columns(names, COLUMN_COUNT)

    print_rows(rows)
  end

  def layout_by_columns(names, column_count)
    row_count = names.length.ceildiv(column_count)
    rows = Array.new(row_count) { [] }

    names.each_with_index do |name, index|
      row_index = index % row_count
      rows[row_index] << name
    end

    rows
  end

  def print_rows(rows)
    max_name_length = rows.flatten.map(&:length).max

    rows.each do |row|
      row.each do |name|
        printf("%-#{max_name_length}s\t", name)
      end
      puts
    end
  end
end
