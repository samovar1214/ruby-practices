# frozen_string_literal: true

class Entry
  attr_reader :name

  def initialize(path)
    @name = File.basename(path)
    @stat = File.lstat(path)
  end

  def ftype
    @stat.ftype
  end

  def mode
    @stat.mode
  end

  def nlink
    @stat.nlink
  end

  def uid
    @stat.uid
  end

  def gid
    @stat.gid
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end

  def blocks
    @stat.blocks
  end
end
