class Computer
	def initialize(ram)
		@rom = ram
		@pos = 0
	end

	def read
		val = @ram[@pos]
		@pos += 1
		val 		
	end

	def readVal(mode)
		mode == 0 ? @ram[read] : read 
	end

	def run(input)
		@ram = @rom.dup
		@pos = 0
		outputs = []
		loop do
			instruction = read.to_s.rjust(5, "0")
			opcode = instruction[-2..-1].to_i
			mode = instruction[0..-3].split("").map(&:to_i).reverse
			case opcode
			when 1
				a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
				@ram[r] = a + b
			when 2
				a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
				@ram[r] = a * b
			when 3
				a = read
				@ram[a] = input.shift.to_i
			when 4
				a = readVal(mode[0])
				outputs << a
			when 5
				a, b = [readVal(mode[0]), readVal(mode[1])]
				@pos = b if a > 0
			when 6
				a, b = [readVal(mode[0]), readVal(mode[1])]
				@pos = b if a == 0
			when 7
				a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
				@ram[r] = a < b ? 1 : 0
			when 8
				a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
				@ram[r] = a == b ? 1 : 0
			when 99
				break
			else
				raise "unexpected opcode #{opcode}"
			end
		end
		return outputs
	end
end

rom = File.read('data.txt').split(",").map(&:to_i)
computer = Computer.new(rom)
puts "output 1: #{computer.run([1])}"
puts "output 2: #{computer.run([5])}"

#### TESTS

def assert_eq(v1, v2)
	raise "expected #{v1} == #{v2}" unless v1 == v2
end

computer = Computer.new([1002,4,3,4,33])
assert_eq computer.run([]), []

computer = Computer.new([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99])
assert_eq computer.run([1]).first, 999
assert_eq computer.run([7]).first, 999
assert_eq computer.run([8]).first, 1000
assert_eq computer.run([9]).first, 1001
assert_eq computer.run([20]).first, 1001

