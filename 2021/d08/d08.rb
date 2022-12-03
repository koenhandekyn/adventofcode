 q# filename = "test.txt"
filename = "input.txt"

input = File.readlines(filename)

@digits = input.map { |s| s.split("|").map(&:split) }
@outputs = @digits.map { |a| a[1] }.flatten
@unique = @outputs.filter { |o| [2, 3, 4, 7].include? o.length }

puts @unique.count

DIGITS =
  { [0,1,2,  4,5,6] => 0 ,
    [    2,    5  ] => 1 ,
    [0,  2,3,4,  6] => 2 ,
    [0,  2,3,  5,6] => 3 ,
    [  1,2,3,  5  ] => 4 ,
    [0,1,  3,  5,6] => 5 ,
    [0,1,  3,4,5,6] => 6 ,
    [0,  2,    5  ] => 7 ,
    [0,1,2,3,4,5,6] => 8 ,
    [0,1,2,3,  5,6] => 9 }

def mapping_from(inputs)
  mapping = Array.new(7,["a", "b", "c", "d", "e", "f", "g"])
  inputs_by_size = inputs.uniq.map { |a| [a.length, a.split("")]}
  size = ->(n) { inputs_by_size.select { |a,b| a == n }.map { |a,b| b } }
  appears = ->(s, c) { size.(s).flatten.tally.filter { |a,b| b == c }.keys }
  mapping[0] = mapping[0] - size.(2).first & size.(3).first - size.(4).first & appears.(5, 3) & appears.(6, 3)
  mapping[1] = mapping[1] - size.(2).first - size.(3).first & size.(4).first & appears.(5, 1) & appears.(6, 3)
  mapping[2] = mapping[2] & size.(2).first & size.(3).first & size.(4).first & appears.(5, 2) & appears.(6, 2)
  mapping[3] = mapping[3] - size.(2).first - size.(3).first & size.(4).first & appears.(5, 3) & appears.(6, 2)
  mapping[4] = mapping[4] - size.(2).first - size.(3).first - size.(4).first & appears.(5, 1) & appears.(6, 2)
  mapping[5] = mapping[5] & size.(2).first & size.(3).first & size.(4).first & appears.(5, 2) & appears.(6, 3)
  mapping[6] = mapping[6] - size.(2).first - size.(3).first - size.(4).first & appears.(5, 3) & appears.(6, 3)
  mapping.map(&:first)
end

def decode(mapping, chars)
  DIGITS[mapping.each_with_index.map { |c, i| chars.include?(c) ? i : nil }.compact]
end

values = @digits.map do |digits|
  mapping = mapping_from(digits[0])
  value = digits[1].map { |digits| decode(mapping, digits).to_s }.join.to_i
end

puts values.sum


# ANALYSIS
##########################################################################################
#     0,1,2,3,4,5,6,7,8,9
#########################    7       2          3            4         5         6
## 0: 0,  2,3  ,5,6,7,8,9 => abcdefg -ab =cdefg &dab = d     -eafb =d  &cdf =d   &bcde =d
## 1: 0,      4,5,6,  8,9 => abcdefg -ab =cdefg -dab = cefg  &eafb =ef &eg  =e   &bcde =e
## 2: 0,1,2,3,4,    7,8,9 => abcdefg &ab =ab    &dab = ab    &eafb =ab &ab  =ab  &afg  =a
## 3:     2,3,4,5,6,  8,9 => abcdefg -ab =cdefg -dab = cefg  &eafb =ef &cdf =f   &afg  =f
## 4: 0,  2,      6,  8   => abcdefg -ab =cdefg -dab = cefg  -eafb =cg &eg  =g   &afg  =g
## 5: 0,1,  3,4,5,6,7,8,9 => abcdefg &ab =ab    &dab = ab    &eafb =ab &ab  =ab  &bcde =b
## 6: 0,  2,3,  5,6,  8,9 => abcdefg -ab =cdefg -dab = cefg  -eafb =cg &cdf =cg  &bcde =c
#########################
#  #  6,2,5,5,4,5,6,3,7,6

################## 5 leds on case
#  bcdef      5
# a cd fg     2
# abcd f      3
# =======
# 2233131

# 0 = cdf   # 3 must appear in all three
# 1 = eg    # 1 must appear once
# 2 = ab    # 2 must appear twice
# 3 = cdf   # 3 must appear in all three
# 4 = eg    # 1 must appear once
# 5 = ab    # 2 must appear twice
# 6 = cdf   # 3 must appear in all three


################## 6 leds on case
# abcdef     9
# abcde g    0
#  bcdefg    6
# ============
# 2333322

# 0 = bcde  # 3
# 1 = bcde  # 3
# 2 = afg   # 2
# 3 = afg   # 2
# 4 = afg   # 2
# 5 = bcde  # 3
# 6 = bcde  # 3
