# filename = "test.txt"
filename = "input.txt"

parsed = File.readlines(filename)
             .map { |s| s.split("->").map { |p| p.split(",").map(&:strip).map(&:to_i) } }
             .map(&:flatten)

def draw(world, x1, y1, x2, y2)
  if x1 == x2
    (y1 < y2 ? y1..y2 : y2..y1).each { |i| world[i][x1] += 1 }
  elsif y1 == y2
    (x1 < x2 ? x1..x2 : x2..x1).each { |i| world[y1][i] += 1 }
  else  # diagonal
    factor = x1 - y1 == x2 - y2 ? 1 : -1 # up or down
    x1, y1, x2, y2 = x1 > x2 ? [x2, y2, x1, y1] : [x1, y1, x2, y2]
    (x1..x2).each_with_index { |i, j| world[y1+factor*j][i] += 1 }
  end
end

wx = parsed.map { |x1,  _, x2,  _| [x1, x2] }.flatten.max + 1
wy = parsed.map { | _, y1,  _, y2| [y1, y2] }.flatten.max + 1
world = Array.new(wy){ Array.new(wx, 0) }

# group by non-diag/diag
hor_or_ver = parsed.group_by { |x1, y1, x2, y2| x1 == x2 || y1 == y2 }

# all except diagonals
hor_or_ver[true].each { |x1, y1, x2, y2| draw(world, x1, y1, x2, y2) }
puts world.flatten.count { |i| i >= 2 }

##############################

# add the diagonals
hor_or_ver[false].each { |x1, y1, x2, y2| draw(world, x1, y1, x2, y2) }
puts world.flatten.count { |i| i >= 2 }

