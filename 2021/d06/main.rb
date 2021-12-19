# filename = "test.txt"
filename = "input.txt"

@fish = File.read(filename).split(",").map(&:to_i)

def tick
  @fish.map! { |f| f -= 1 }
  @fish.count(-1).times { @fish << 8 }
  @fish.map! { |f| f == -1 ? 6 : f }
end

80.times { tick }
puts @fish.count # 393019

###########################################

@fish = File.read(filename).split(",").map(&:to_i).tally

def tock
  (0..8).each { |i| @fish[i-1] = @fish[i] || 0 }
  @fish[8], @fish[6], @fish[-1] = @fish[-1], @fish[6] + @fish[-1], 0
end

256.times { tock }
puts @fish.values.sum # 393019
