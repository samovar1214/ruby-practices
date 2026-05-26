# frozen_string_literal: true

require 'etc'

class Entry
  attr_reader :name

  def initialize(path)
    @name = File.basename(path)
    @stat = File.lstat(path)
  end

  def mode
    filetype_table = {
      'directory' => 'd',
      'file' => '-',
      'link' => 'l'
    }

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

    type = filetype_table[@stat.ftype]
    permissions = @stat.mode.to_s(8)[-3, 3].chars.map(&filemode_table).join
    type + permissions
  end

  def nlink
    @stat.nlink.to_s
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def mtime
    @stat.mtime.strftime('%b %e %H:%M')
  end

  def blocks
    @stat.blocks
  end
end
