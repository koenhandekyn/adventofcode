depth = aimed_depth = horizontal = 0
File.readlines('input.txt')
    .each do |command|
      instruction, amount = command.split
      amount = amount.to_i
      case instruction
      when "down"
        depth += amount
      when "up"
        depth -= amount
      when "forward"
        horizontal += amount
        aimed_depth += depth * amount
      end
    end

puts horizontal * depth
puts horizontal * aimed_depth
