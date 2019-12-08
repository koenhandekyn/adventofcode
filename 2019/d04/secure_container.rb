def assert_eq(v1, v2)
	raise "expected #{v2}, but got #{v1}" unless v1 == v2
end

lower = 206938
upper = 679128

candidates = 
	(0..9).map do |d1|
		(d1..9).map do |d2|
			(d2..9).map do |d3|
				(d3..9).map do |d4|
					(d4..9).map do |d5|
						(d5..9).map do |d6|
							[d1,d2,d3,d4,d5,d6].join("")
						end
					end
				end
			end
		end
	end
	.flatten	
	.select { |c| (0..4).map { |i| c[i] == c[i+1] }.any? }
	.select { |c| i = c.to_i; i >= lower && i <= upper }

puts "initial candidates: #{candidates.size}" 

def c3(c) 
	(0..4).map { |i| c[i-1] != c[i] && c[i] == c[i+1] && c[i+1] != c[i+2] }.any?
end

assert_eq c3("112233"), true
assert_eq c3("123444"), false
assert_eq c3("111122"), true

candidates = candidates.select { |c| c3(c) }

puts "remaining candidates: #{candidates.size}"
