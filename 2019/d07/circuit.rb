require_relative 'computer'

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

##### part 1

def run_circuit(phases, program)
  computer = Computer.new(program)
  phases.inject(0) { |a, b| computer.runWithInputs([b,a]) }
end

def maximum_output(program)
  (0..4).to_a.permutation(5).map { |c| run_circuit(c, program) }.max
end

# the program source

code = [3,8,1001,8,10,8,105,1,0,0,21,30,55,76,97,114,195,276,357,438,99999,3,9,102,3,9,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,2,9,1001,9,2,9,102,2,9,9,4,9,99,3,9,1002,9,5,9,1001,9,2,9,102,5,9,9,1001,9,4,9,4,9,99,3,9,1001,9,4,9,102,5,9,9,101,4,9,9,1002,9,4,9,4,9,99,3,9,101,2,9,9,102,4,9,9,1001,9,5,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99]

puts "max output : #{maximum_output(code)}"

#### test part 1

assert_eq run_circuit([4,3,2,1,0], [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]), 43210
assert_eq run_circuit([0,1,2,3,4], [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]), 54321

def maximize(program)
  (0..4).to_a.permutation(5).max_by { |c| run_circuit(c, program) }
end

assert_eq maximize([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]), [4,3,2,1,0]
assert_eq maximize([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]), [0,1,2,3,4]

#####  part 2

def loopCircuits(phases, code)
  circuits = (0..4).map { |_| Computer.new(code) }
  qs = (0..4).map { |i| Queue.new << phases[i] }
  qs[0] << 0
  (0..4).map { |i| Thread.new { circuits[i % 5].run(qs[i % 5], qs[(i+1) % 5]) } }
        .each(&:join)
  qs[0].pop
end

def maximum_feedback_output(program)
  (5..9).to_a.permutation(5).map { |c| loopCircuits(c, program) }.max
end

puts "max feedback output : #{maximum_feedback_output(code)}"

##### test part 2

assert_eq loopCircuits([9,8,7,6,5], [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]), 139629729
