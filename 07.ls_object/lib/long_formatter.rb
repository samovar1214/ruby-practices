# frozen_string_literal: true

require 'etc'

class LongFormatter
  FILETYPE_TABLE = {
    'directory' => 'd',
    'file' => '-',
    'link' => 'l'
  }.freeze

  FILEMODE_TABLE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(entries)
    @entries = entries
  end

  def format
    @entries.map do |entry|
      [
        format_mode(entry),
        entry.nlink.to_s,
        Etc.getpwuid(entry.uid).name,
        Etc.getgrgid(entry.gid).name,
        entry.size.to_s.rjust(4),
        entry.mtime.strftime('%b %e %H:%M'),
        entry.name
      ].join(' ')
    end
  end

  private

  def format_mode(entry)
    type = FILETYPE_TABLE[entry.ftype]
    permissions = entry.mode.to_s(8)[-3, 3].chars.map(&FILEMODE_TABLE).join
    type + permissions
  end
end
