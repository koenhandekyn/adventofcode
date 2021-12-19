# maze.rb

require 'matrix'

# stateless
def to_pos_to_val(matrix)
  pos_to_val = {}
  matrix.reverse.each_with_index do |row, y|
    row.each_with_index do |val, x|
      pos_to_val[Complex(x,y)] = val if val != "#"
    end
  end
  pos_to_val
end

class Maze
  MOVES = {up: +1i, down: -1i, left: -1, right: +1}
  attr_reader :pos, :pos_to_val
  def initialize(filename)
    @matrix = File.read(filename).split("\n").map { |r| r.split("") }
    @pos_to_val = to_pos_to_val(@matrix)
  end
  def find_start()
    @pos_to_val.find { |k, v| v == "@" }.first
  end
  def to_s
    @matrix.map { |cols| cols.join() }.join("\n")
  end
end

m = Maze.new("maze1.txt")
puts m
puts m.pos_to_val
puts m.find_start.inspect
# puts m.pos