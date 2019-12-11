require_relative 'computer'

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

##### part 1
computer = Computer.load("boost.bin", debug: false)
output = computer.runWithArray([1])
puts "test output: #{output}"

output = computer.reset.runWithArray([2])
puts "distress coordinates: #{output}"

#### test part 1

code = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
assert_eq Computer.new(code).runWithArray([]), code
code = [1102,34915192,34915192,7,4,7,99,0]
assert_eq Computer.new(code).runWithArray([]), [1219070632396864]
code = [104,1125899906842624,99]
assert_eq Computer.new(code).runWithArray([]), [1125899906842624]
