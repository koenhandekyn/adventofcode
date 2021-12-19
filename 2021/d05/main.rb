# filename = "test.txt"
filename = "input.txt"

parsed = File.readlines(filename).map { |s| s.split("->").map { |p| p.split(",").map(&:strip).map(&:to_i) } }

def draw(world, from, to)
  if (f = from[0]) == to[0]
    range = from[1] < to[1] ? from[1]..to[1] : to[1]..from[1]
    range.each { |i| world[i][f] += 1 }
  elsif (f = from[1]) == to[1]
    range = from[0] < to[0] ? from[0]..to[0] : to[0]..from[0]
    range.each { |i| world[f][i] += 1 }
  else  # diagonal
    factor = from[0] - from[1] == to[0] - to[1] ? 1 : -1 # up or down
    a, b = from[0] > to[0] ? [to, from] : [from, to]
    (a[0]..b[0]).each_with_index { |i, j| world[a[1]+factor*j][i] += 1 }
  end
end

wx, wy = [0,1].map { |i| parsed.map { |p1, p2| [p1[i], p2[i]] }.flatten.max + 1 }
world = Array.new(wy){Array.new(wx, 0)}

hor_or_ver = parsed.group_by { |p1, p2| p1[0] == p2[0] || p1[1] == p2[1] }
hor_or_ver[true].each { |from, to| draw(world, from, to) }
puts world.flatten.select { |i| i >= 2 }.count

##############################

hor_or_ver[false].each { |from, to| draw(world, from, to) }
puts world.flatten.select { |i| i >= 2 }.count

