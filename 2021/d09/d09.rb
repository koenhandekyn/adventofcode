# filename = "test.txt"
filename = "input.txt"

@inputs = File.readlines(filename)
              .map { |s| s.strip.split("").map(&:to_i) }

class Range
  def product(range)
    self.to_a.product(range.to_a)
  end
end

@w, @h = [@inputs.size, @inputs[0].size]
low_points =
  (0..@w-1).product(0..@h-1).map do |x,y|
    if (x==0    || @inputs[x][y] < @inputs[x-1][y]) &&
       (y==0    || @inputs[x][y] < @inputs[x][y-1]) &&
       (x==@w-1 || @inputs[x][y] < @inputs[x+1][y]) &&
       (y==@h-1 || @inputs[x][y] < @inputs[x][y+1])
       [x,y]
     end
  end.compact

puts low_points.map { |x,y| @inputs[x][y] + 1 }.sum

def flow(basin, flow_to)
  if basin.include?(flow_to)
    basin
  else
    x, y = flow_to
    basin << flow_to
    basin = flow(basin, [x-1,y]) if x!=0    && @inputs[x-1][y] < 9
    basin = flow(basin, [x,y-1]) if y!=0    && @inputs[x][y-1] < 9
    basin = flow(basin, [x+1,y]) if x!=@w-1 && @inputs[x+1][y] < 9
    basin = flow(basin, [x,y+1]) if y!=@h-1 && @inputs[x][y+1] < 9
    basin
  end
end

puts low_points.map { |low_point| flow([], low_point).size }
               .sort
               .reverse
               .take(3)
               .reduce(&:*)
