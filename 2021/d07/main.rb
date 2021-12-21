# filename = "test.txt"
filename = "input.txt"

@crab = File.read(filename)
            .split(",")
            .map(&:to_i)

def diff(n)
  @crab.map { |i| (i-n).abs }.sum
end

def optimize(n, m)
  if n == m
    diff(n)
  elsif n - m == 1
    [diff(n), diff(m)].min
  else
    diff(n) > diff(m) ? optimize((n+m)/2, m) : optimize(n, (n+m)/2)
  end
end

puts optimize(@crab.min, @crab.max)

#################################

# cache fuel needs
@fuel = (1..(@crab.max-@crab.min)+1).map { |i| i.times.reduce(0) { |a,s| a+s } }

def diff(n)
  @crab.map { |i| @fuel[(i-n).abs] }.sum
end

puts optimize(@crab.min, @crab.max)


