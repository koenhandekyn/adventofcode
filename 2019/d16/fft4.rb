require "matrix"

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

def pattern(i)
  p = [0,1,0,-1].map { |x| Array.new(i+1, x) }.flatten
end

def pattern_len(i, len)
  p = pattern(i)
  (p * (len / p.size + 1)).drop(1).take(len)
end

def transformer(len)
  Matrix[*(0..len-1).map { |i| pattern_len(i, len) }].transpose
end

class FFT
  def initialize(input)
    values = input.split("").map { |s| s.to_i }
    @state = Matrix[values]
    @len = values.size
    @transformer = transformer(@len)
  end
  def run(n)
    # n.times do
      @state = @state * @transformer ** 100
      @state = Matrix[@state.to_a[0].map { |x| x.abs % 10}]
    # end
    @state.to_a[0][0..7].join("")
  end
end


input = "59790132880344516900093091154955597199863490073342910249565395038806135885706290664499164028251508292041959926849162473699550018653393834944216172810195882161876866188294352485183178740261279280213486011018791012560046012995409807741782162189252951939029564062935408459914894373210511494699108265315264830173403743547300700976944780004513514866386570658448247527151658945604790687693036691590606045331434271899594734825392560698221510565391059565109571638751133487824774572142934078485772422422132834305704887084146829228294925039109858598295988853017494057928948890390543290199918610303090142501490713145935617325806587528883833726972378426243439037"
# puts FFT.new(input).run(100)
puts (transformer(200)**100)
# puts (transformer(10)**100)

a = Matrix["12345678".split("").map { |s| s.to_i }]
b = transformer(8)
# puts a
# puts b
# puts (a * b).to_a[0].map { |i| i.abs % 10 }.inspect
# puts b ** 2
# puts (a * b * b).to_a[0].map { |i| i.abs % 10 }.inspect
# puts FFT.new(input).run(100)

# assert_eq pattern_len(0, 8), [1, 0, -1, 0, 1, 0, -1, 0]
# assert_eq pattern_len(1, 8), [0, 1, 1, 0, 0, -1, -1, 0]

assert_eq FFT.new("12345678").run(4), "01029498"
assert_eq FFT.new("80871224585914546619083218645595").run(100), "24176176"
