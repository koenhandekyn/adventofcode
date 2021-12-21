numbers =
  File
    .readlines('d01.txt')
    .map(&:to_i)

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

puts increments.(sliding_sums)
