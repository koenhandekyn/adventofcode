# require "curses"

require_relative "../d09/computer"

class Maze
  D = [+1i, -1i, -1, +1] # moves
  I = [1,0,3,2] # inverted move indexes
  V = [":", " ", "O"] # tiles
  def initialize()
    @maze = {}
    @maze[0+0i] = " "
    @input, @output = Queue.new, Queue.new
    @computer = Computer.load("maze.intcode", debug: false)
    map
  end
  def map()
    @run = Thread.new { @computer.run(@input, @output) }
    path = walk(0+0i, nil)
  end
  def do_move(move)
    @input << move+1
    popped = @output.pop
    # raise "issue #{popped}" unless popped == 1
  end
  def walk(p, exclude)
    (0..3).each do |move|
      np = p + D[move]
      if move != exclude && @maze[np] == nil
        response = do_move(move)
        @maze[np]=V[response]
        case response
        when 1
          walk(np, I[move])
          do_move(I[move])
        when 2
          @target = np
          do_move(I[move])
        end
      end
    end
  end
  def shortest_path_to_target(p = 0+0i, exclude = nil, distance = 0)
    if p == @target
      return distance
    else
      return (0..3).map do |move|
        np = p + D[move]
        if move != exclude && @maze[np] != ":"
          shortest_path_to_target(np, I[move], distance + 1)
        end
      end.compact.min
    end
  end
  def minutes_to_fill(p = @target, m = 0)
    (0..3).map do |move|
      np = p + D[move]
      if @maze[np] == " "
        @maze[np]="O"
        minutes_to_fill(np, m + 1)
      else
        m
      end
    end.compact.max
  end
  def paint_to_strings(at = 0+0i)
    @maze[at], old = '@', @maze[at]
    xs = @maze.map { |(p, _)| p.real }
    ys = @maze.map { |(p, _)| p.imag }
    width  = xs.max-(minx = xs.min)+1
    height = ys.max-(miny = ys.min)+1
    screen = @maze
      .inject( Array.new(height) { Array.new(width) { "--" } } ) do |screen, (p, c)|
        screen[p.imag-miny][p.real-minx] = "#{c}#{c}"
        screen
      end
      .reverse
      .map(&:join)
    @maze[at] = old
    screen
  end
end

maze = Maze.new
puts maze.paint_to_strings
puts "shortest path #{maze.shortest_path_to_target}"
puts "minutes to fill #{maze.minutes_to_fill}"