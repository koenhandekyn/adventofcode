def run(ram)
	ram.each_slice(4) do |opcode, a, b, result|	
		case opcode
		when 1
			ram[result] = ram[a] + ram[b]
		when 2
			ram[result] = ram[a] * ram[b]
		when 99
			return ram
		end
	end
end

CODE = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,19,10,23,2,13,23,27,1,5,27,31,2,6,31,35,1,6,35,39,2,39,9,43,1,5,43,47,1,13,47,51,1,10,51,55,2,55,10,59,2,10,59,63,1,9,63,67,2,67,13,71,1,71,6,75,2,6,75,79,1,5,79,83,2,83,9,87,1,6,87,91,2,91,6,95,1,95,6,99,2,99,13,103,1,6,103,107,1,2,107,111,1,111,9,0,99,2,14,0,0].freeze

def run_with_input(a,b)
	ram = CODE.dup
	ram[1] = a
	ram[2] = b
  run(ram)[0]
end

puts "value at pos(0) after run: #{run_with_input(12,2)}"

catch :done do
	(0..99).each do |noun|
		(0..99).each do |verb|
			if run_with_input(noun, verb) == 19690720
				puts "answer = 100 * noun + verb = #{100 * noun + verb}"
				throw :done
			end
		end
	end
end

# functional variant
tuple = 
	(0..99).to_a
		.product((0..99).to_a)
		.find { |noun, verb| run_with_input(noun, verb) == 19690720 }

answer =  ->(noun, verb) { 100 * noun + verb }.(*tuple)

puts "answer = 100 * noun + verb = #{answer}"

##### TESTS

def assert_eq(v1, v2)
	raise "expected #{v1} == #{v2}" unless v1 == v2
end

assert_eq run([1,9,10,3,2,3,11,0,99,30,40,50]), [3500,9,10,70,2,3,11,0,99,30,40,50]
assert_eq run([1,1,1,4,99,5,6,0,99]), [30,1,1,4,2,5,6,0,99]
assert_eq run([2,4,4,5,99,0]), [2,4,4,5,99,9801]


