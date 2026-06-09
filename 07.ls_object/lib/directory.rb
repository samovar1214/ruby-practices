# frozen_string_literal: true

require_relative 'entry'

class Directory
  def initialize(path, all: false, reverse: false)
    @path = path
    @all = all
    @reverse = reverse
  end

  def entries
    glob_option = @all ? File::FNM_DOTMATCH : 0
    paths = Dir.glob('*', glob_option).sort

    entries = paths.map { |path| Entry.new(path) }
    @reverse ? entries.reverse : entries
  end

  def total_blocks
    entries.sum(&:blocks) / 2
  end
end
