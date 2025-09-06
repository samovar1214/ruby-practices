#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

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

def render_filetype_and_filemode(file_info)
  filetype_table = {
    'directory' => 'd',
    'file' => '-',
    'link' => 'l'
  }

  filetype = filetype_table[file_info.ftype]

  filemode_table = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }

  mode_octal = file_info.mode.to_s(8)[-3, 3]
  filemode = mode_octal.chars.map { |mode_digit| filemode_table[mode_digit] }.join

  filetype + filemode
end

def print_long_format(filenames)
  file_infos = filenames.map { |filename| [filename, File.lstat(filename)] }

  total_blocks = file_infos.sum { |_, file_info| file_info.blocks } / 2
  puts "total #{total_blocks}"

  file_infos.each do |filename, file_info|
    printf(
      "%<mode>s %<links>d %<owner>s %<group>s %<size>4d %<mtime>s %<name>s\n",
      mode: render_filetype_and_filemode(file_info),
      links: file_info.nlink,
      owner: Etc.getpwuid(file_info.uid).name,
      group: Etc.getgrgid(file_info.gid).name,
      size: file_info.size,
      mtime: file_info.mtime.strftime('%b %e %H:%M'),
      name: filename
    )
  end
end

options = ARGV.getopts('arl')

glob_option = options['a'] ? File::FNM_DOTMATCH : 0
filenames = Dir.glob('*', glob_option).sort

filenames.reverse! if options['r']

if options['l']
  print_long_format(filenames)
else
  column_count = 3
  rows = layout_by_columns(filenames, column_count)
  print_rows(rows)
end
