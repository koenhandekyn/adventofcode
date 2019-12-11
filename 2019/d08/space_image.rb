img = File.read("image.bin").split("").map(&:to_i)

layers = img.each_slice(25*6).to_a

layer_min_zero = layers.min_by { |layer| layer.count(0) }

lmz1s = layer_min_zero.count(1)
lmz2s = layer_min_zero.count(2)

puts "1s * 2s for layer with min 0s = #{lmz1s} * #{lmz2s} = #{lmz1s * lmz2s}\n\n"

decoded = []
layers.each do |layer|
  layer.each_with_index do |v, i|
    decoded[i] ||= " " if v == 0
    decoded[i] ||= "X" if v == 1
  end
end

decoded.each_slice(25) do |row|
  puts row.join(" ")
end