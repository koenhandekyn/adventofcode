require_relative "../d09/computer"

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

# using complex numbers for representing coordiantes
class Painter

  # orientations = [:top, :right, :bottom, :left]
  ORIENTATIONS = [+1i, 1, -1i, -1]

  def initialize()
    @computer = Computer.load("paint.bin", debug: false)
  end

  def paint(init)
    inputs, outputs = Queue.new, Queue.new
    panels = {}
    inputs << (panels[pos = 0+0i] = init)
    orientation = 0 # 0 to 3
    t = Thread.new { @computer.run(inputs, outputs) }
    while t.status != false
      panels[pos] = outputs.pop # paint color
      left_or_right = (outputs.pop == 0 ? -1 : 1)
      orientation = (orientation + left_or_right) % 4
      inputs << panels[pos += ORIENTATIONS[orientation]].to_i # move and read input
    end
    @computer.reset
    panels
  end

  def paint_to_strings(init)
    panels = paint(init)
    xs = panels.map { |(p, _)| p.real }
    ys = panels.map { |(p, _)| p.imag }
    width  = xs.max-(minx = xs.min)+1
    height = ys.max-(miny = ys.min)+1
    panels
      .inject( Array.new(height) { Array.new(width) { " " } } ) do |screen, (p, c)|
        screen[p.imag-miny][p.real-minx] = "X" if c == 1
        screen
      end
      .reverse
      .map(&:join)
  end
end

painter = Painter.new
puts "initial parts painted: #{painter.paint(0).length}\n"
puts "\nlicense:\n\n"
puts painter.paint_to_strings(1)