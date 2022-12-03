sums = 
    File.readlines('input.txt', chomp: true)
        .chunk { |e| e == "" }
        .map { |bool, arr| arr.map(&:to_i).sum }
        .sort

puts sums.last
puts sums.last(3).sum