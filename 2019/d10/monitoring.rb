require 'set'

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
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

def count_visible(asteroids)
  Hash[
    asteroids.map do |(x1, y1)|
      lines_of_sight =
        asteroids
          .inject({}) do |lines, (x2,y2)|
            unless [x1,y1] == [x2, y2]
              m = (y2 - y1).to_r / (x2 - x1) unless (x2 - x1) == 0
              (lines[m] ||= Set.new) << [x2, y2]
            end
            lines
          end
      count_per_lines_of_sight =
        lines_of_sight
          .map do |_,asts|
            # special case with one element also fine
            if [x1] == asts.map { |(x,_)| x }.uniq # vertical line
              asts.group_by { |(_, y2)| y2 > y1 }.count
            else
              asts.group_by { |(x2, _)| x2 > x1 }.count
            end
          end.compact.sum
      [[x1,y1], count_per_lines_of_sight]
    end
  ]
end

def best_location(asteroids)
  count_visible(asteroids)
    .max_by { |c,v| v }
end

# asteroids = read_coordinates("puzzle.map")
# puts best_location(asteroids).inspect

# asteroids = read_coordinates("sample1.map")
# assert_eq best_location(asteroids), [[3,4], 8]

# asteroids = read_coordinates("sample2.map")
# assert_eq best_location(asteroids), [[5,8], 33]

# asteroids = read_coordinates("sample3.map")
# assert_eq best_location(asteroids), [[1,2], 35]

# asteroids = read_coordinates("sample4.map")
# assert_eq best_location(asteroids), [[6,3], 41]

asteroids = read_coordinates("sample5.map")
assert_eq best_location(asteroids), [[11,13], 210]

def blast((x1,y1), asteroids)
  lines_of_sight =
    asteroids
      .inject({}) do |lines, (x2,y2)|
        unless [x1,y1] == [x2, y2]
          m = (x2 - x1) == 0 ? Float::INFINITY : 1.0 * (y2 - y1) / (x2 - x1)
          (lines[m] ||= Set.new) << [x2, y2]
        end
        lines
      end.sort_by { |k,v| -k }
  puts lines_of_sight.inspect
end

blast([11,13], asteroids)
