require 'set'

def read_coordinates(filename)
  File
    .readlines(filename)
    .reverse
    .each_with_index
    .map do |row, y|
      row.strip.split("").each_with_index.map do |val, x|
        [x,y] if val == "#"
      end
    end
    .flatten(1)
    .compact
end

asteroids = read_coordinates("sample1.map")
# asteroids = read_coordinates("puzzle.map")
combos = asteroids.combination(2)

lines2asteroids = combos.inject({}) do |lines, ((x1, y1), (x2, y2))|
  m = (y2 - y1) / (x2 - x1) unless (x2 - x1) == 0
  q = -x1 * (y2 - y1) + y1
  (lines[[m,q]] ||= Set.new) << [x1, y1] << [x2, y2]
  lines
end

puts asteroids.count
puts combos.count
puts lines2asteroids.count
# puts lines2asteroids.inspect
puts lines2asteroids.select { |k,v| v.count > 2}.count

# asteroids = read_coordinates("puzzle.map")
# puts asteroids.combination(2).to_a.count

