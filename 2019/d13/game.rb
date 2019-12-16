require 'curses'

require_relative "../d09/computer"

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

class Game
  TILES = [' ', '|', '.', '_', 'O']
  def initialize()
    @computer = Computer.load("game.intcode", debug: false)
  end
  def block_tiles_on_screen
    @computer
      .runWithArray([])
      .each_slice(3)
      .inject({}) { |h, (x,y,t)| h[[x,y]] = t; h }
      .select { |k,v| v == 2 } # block tile
      .size
  end
  def play_for_free()
    @computer.rom[0] = 2
    @computer.reset
    input, output = Queue.new, Queue.new
    t1 = Thread.new {
      @computer.run(input, output)
    }
    t2 = Thread.new {
      loop do
        Curses.refresh
        x, y, t = output.pop, output.pop, output.pop
        @ball = x if t == 4
        @paddle = x if t == 3
        Curses.setpos(y+4, x)
        Curses.addstr(TILES[t]) if x >= 0
        if x == -1 && y == 0
          @score = t
          Curses.setpos(0, 0)
          Curses.addstr(t.to_s)
        end
        Curses.setpos(2, 0)
      end
    }
    t3 = Thread.new {
      loop do
        sleep(1.0/100.0)
        if @ball && @paddle
          if @ball < @paddle
            input << -1
          elsif @ball > @paddle
            input << +1
          else
            input << 0
          end
        end
      end
    }
    t1.join
    sleep(10)
  end
end

Game.new.play_for_free