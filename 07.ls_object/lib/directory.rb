# frozen_string_literal: true

require_relative 'entry'

class Directory
  def initialize(path, options)
    @path = path
    @options = options
  end

  def entries
    glob_option = @options[:a] ? File::FNM_DOTMATCH : 0
    paths = Dir.glob('*', glob_option).sort

    entries = paths.map { |path| Entry.new(path) }
    @options[:r] ? entries.reverse : entries
  end

  def total_blocks
    entries.sum(&:blocks) / 2
  end
end
