consumptions =
  File.readlines('input.txt')
      .map { |s| s.strip.each_char.map(&:to_i) }

counts =
  consumptions
    .transpose
    .map(&:tally)

most  = ->(h) { h[0].to_i >  h[1].to_i ? 0 : 1 }
least = ->(h) { h[0].to_i <= h[1].to_i ? 0 : 1 }

gamma, epsilon =
  counts
    .map { |counts| [m = most.(counts), 1 - m] } # least.(counts)
    .transpose
    .map(&:join)
    .map { |s| s.to_i(2) }

puts gamma * epsilon # 775304

#################################

def filter(consumptions, comparator, index = 0)
  return consumptions[0] if consumptions.length == 1
  counts = consumptions.transpose[index].tally # ya i know should filter first
  filter(
    consumptions.select { |c| c[index] == comparator.(counts) },
    comparator,
    index+1
  )
end

oxygen = filter(consumptions, most ).join.to_i(2)
co2    = filter(consumptions, least).join.to_i(2)

puts oxygen * co2 # 1370737
