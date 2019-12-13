require 'set'

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

class Asteroids

  def initialize(filename)
    @asteroids = read_coordinates(filename)
  end

  def read_coordinates(filename)
    File
      .readlines(filename)
      .each_with_index
      .map do |row, y|
        row.strip.split("").each_with_index.map do |val, x|
          [x,y] if val == "#"
        end
      end
      .flatten(1)
      .compact
  end

  def distance(x1, y1, x2, y2)
    Math.sqrt((x2-x1)**2+(y2-y1)**2)
  end

  def lines_of_sight(x1,y1)
    memo ||= {}
    memo[[x1,y1]] ||=
      @asteroids
        .inject({}) do |lines, (x2,y2)|
          unless [x1,y1] == [x2, y2]
            # we need to negate y to come to a normal eucledian axis
            # we need to negate theta because we rotate counter clockwise
            theta = - (Math.atan2(-(y2-y1), x2-x1) - Math::PI / 2)
            theta += Math::PI * 2 if theta < 0
            (lines[theta] ||= Set.new) << [x2, y2]
          end
          lines
        end
  end

  def lines_of_sight_sorted(x1,y1)
    lines_of_sight(x1,y1)
      .map do |theta, asteroids|
        [theta, asteroids.sort_by { |(x2, y2)| distance(x1,y1,x2, y2) }]
      end
      .sort_by { |k,v| k }
  end

  def count_visible
    Hash[
      @asteroids.map do |(x1, y1)|
        [[x1,y1], lines_of_sight(x1,y1).count]
      end
    ]
  end

  def blast((x1,y1))
    lines = lines_of_sight_sorted(x1,y1)
    count = 0
    loop do
      lines.each do |theta, line|
        count += 1
        return line.shift if count == 200
      end
    end
  end

  def best_location
    count_visible
      .max_by { |c,v| v }
  end
end

asteroids = Asteroids.new("puzzle.map")
station, visible = asteroids.best_location
puts "station @ #{station.inspect}, visible = #{visible}"

blast200 = asteroids.blast(station)
puts "the 200d asteroid blasted is @ #{blast200.inspect} with a value of #{blast200[0]*100+blast200[1]}"

asteroids = Asteroids.new("sample1.map")
assert_eq asteroids.best_location, [[3,4], 8]

asteroids = Asteroids.new("sample2.map")
assert_eq asteroids.best_location, [[5,8], 33]

asteroids = Asteroids.new("sample3.map")
assert_eq asteroids.best_location, [[1,2], 35]

asteroids = Asteroids.new("sample4.map")
assert_eq asteroids.best_location, [[6,3], 41]

asteroids = Asteroids.new("sample5.map")
assert_eq asteroids.best_location, [[11,13], 210]
assert_eq asteroids.blast([11,13]), [8, 2]
