numbers =
  File
    .readlines('d01.txt')
    .map(&:to_i)

# numbers =
#   [199,200,208,210,200,207,240,269,260,263]

increments = ->(numbers) {
  numbers
    .each_cons(2)
    .inject(0) { |cnt, (a, b)| cnt + (b > a ? 1 : 0) }
}

puts increments.(numbers)

sliding_sums =
  numbers
    .each_cons(3)
    .map(&:sum)

# puts sliding_sums

puts increments.(sliding_sums)
