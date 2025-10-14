#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

OPTION_FIELD_MAPPING = [
  [:lines, 'l'],
  [:words, 'w'],
  [:bytes, 'c']
].freeze

def read_stdin
  content = $stdin.read
  ['', count_content(content)]
end

def read_file(filename)
  content = File.read(filename)
  [filename, count_content(content)]
end

def count_content(content)
  {
    lines: content.lines.size,
    words: content.strip.split(/\s+/).size,
    bytes: content.bytesize
  }
end

def format_output(name, counts, options)
  no_option = !options['l'] && !options['w'] && !options['c']

  output_fields = OPTION_FIELD_MAPPING.map do |field, opt|
    counts[field].to_s.rjust(3) if no_option || options[opt]
  end.compact

  output_fields << name
  output_fields.join(' ')
end

options = ARGV.getopts('lwc')
files   = ARGV

file_contents = if files.empty?
                  [read_stdin]
                else
                  files.map { |file| read_file(file) }
                end

total_counts = { lines: 0, words: 0, bytes: 0 }

if file_contents.size > 1
  file_contents.each do |name, counts|
    puts format_output(name, counts, options)
    total_counts[:lines] += counts[:lines]
    total_counts[:words] += counts[:words]
    total_counts[:bytes] += counts[:bytes]
  end
  puts format_output('total', total_counts, options)
else
  name, counts = file_contents.first
  puts format_output(name, counts, options)
end
