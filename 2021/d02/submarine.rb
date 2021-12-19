commands = File.readlines('input.txt').map(&:split)

######################## PART 1

OPS = {
  up: [:d, -1],
  down: [:d, +1],
  forward: [:h, +1]
}

pos = { d: 0, h: 0 }
commands.each do |command|
  instruction, amount_s = command
  p_index, p_factor = OPS[instruction.to_sym]
  pos[p_index] += p_factor * amount_s.to_i
end

puts pos[:d]*pos[:h]

######################## PART 2

depth = horizontal = aim = 0
commands.each do |command|
  instruction, amount_s = command
  amount = amount_s.to_i
  case instruction
  when "down"
    aim += amount
  when "up"
    aim -= amount
  when "forward"
    horizontal += amount
    depth += aim * amount
  end
end

puts depth*horizontal
