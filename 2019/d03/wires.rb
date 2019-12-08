require 'benchmark'

class World
	def initialize(path1, path2)
		@p1 = World::build(path1)
		@p2 = World::build(path2)
		@crosses = @p1 & @p2
	end

	def distance_to_nearest_cross
		@crosses.map { |x,y| x.abs + y.abs }.min
	end

	def total_steps_to_nearest_cross
		@crosses.map { |c| World::steps_to(@p1, c) + World::steps_to(@p2, c) }.min
	end

	def self.build(path)
	  px, py = [0, 0]
	  path.split(",").reduce([]) do |memo, section|
	  	direction, distance = World::parse(section)
			distance.times { px += 1; memo << [px, py] } if direction == 'R'
			distance.times { px -= 1; memo << [px, py] } if direction == 'L'
			distance.times { py += 1; memo << [px, py] } if direction == 'U'
			distance.times { py -= 1; memo << [px, py] } if direction == 'D'
			memo
	  end		
	end

	def self.steps_to(path, c)
		path.find_index(c) + 1
	end

	def self.parse(section)
		[section[0..0], section[1..-1].to_i]
	end	
end

input = File.read('data.txt').split("\n")
path1 = input[0]
path2 = input[1]

puts Benchmark.measure { 
	world = World.new(path1, path2)
	puts "distance to nearest cross #{world.distance_to_nearest_cross}"
	puts "stepts to nearest cross #{world.total_steps_to_nearest_cross}"
}


###### TESTS

test0_1 = "R8,U5,L5,D3"
test0_2 = "U7,R6,D4,L4"

test1_1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
test1_2 = "U62,R66,U55,R34,D71,R55,D58,R83"

test2_1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
test2_2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"

def assert_eq(v1, v2)
	raise "expected #{v2}, but got #{v1}" unless v1 == v2
end

world0 = World.new(test0_1, test0_2)
assert_eq world0.distance_to_nearest_cross, 6
assert_eq world0.total_steps_to_nearest_cross, 30
puts world0

world1 = World.new(test1_1, test1_2)
assert_eq world1.distance_to_nearest_cross, 159
assert_eq world1.total_steps_to_nearest_cross, 610

world2 = World.new(test2_1, test2_2)
assert_eq world2.distance_to_nearest_cross, 135
assert_eq world2.total_steps_to_nearest_cross, 410

