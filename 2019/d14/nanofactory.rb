# nanofactory.rb

require 'tsort'

class Reaction
  attr_accessor :ins, :out
  def initialize(ins, out, factory)
    @ins = Hash.new(0)
    ins.each { |elem, quantity| @ins[elem] = quantity }
    @out = out
    @factory = factory
  end
  def ore_for(multiple = 1)
    ins = Hash.new(0)
    @ins.each { |elem, quantity| ins[elem] = quantity * multiple }
    @factory.reactions.reverse.each do |reaction|
      needs = ins[reaction.out[0]]
      ins[reaction.out[0]] = 0
      expanded = @factory.expand(reaction.out[0], needs)
      expanded.each { |elem, quantity| ins[elem] += quantity if quantity != 0 }
    end
    ins["ORE"]
  end
  def ins_times(multiplier)
    @ins.map { |elem, quantity| [elem, quantity * multiplier] }
  end
  def self.parse(str, factory)
    ins, outs =
      str
        .split("=>")
        .map do |term|
          term.split(",").map { |t| t.split(" ") }.map { |q, e| [e.strip, q.to_i ]}
        end
    Reaction.new(ins, outs.first, factory)
  end
  def to_s
    "#{@ins.map(&:to_s).join(", ")} => #{@out.map(&:to_s)}"
  end
end

class Factory
  include TSort
  attr_reader :reactions
  def initialize(filename)
    @reactions =
      File
        .readlines(filename)
        .map { |row| Reaction::parse(row, self) }
    @reactions_by_elem =
      Hash[ @reactions.map { |r| [r.out[0], r] } ]
    @reactions = tsort.map { |elem| @reactions_by_elem[elem] }.compact
  end
  def expand(elem, quantity)
    reaction = @reactions_by_elem[elem]
    # if reaction
    multiplier = quantity / reaction.out[1] + ((quantity % reaction.out[1] == 0) ? 0 : 1)
    leftover = quantity - multiplier * reaction.out[1]
    reaction.ins_times(multiplier) + [[elem, leftover]]
    # else
      # [[elem, quantity]]
    # end
  end
  def find(elem)
    @reactions_by_elem[elem]
  end
  def tsort_each_node(&block)
    @reactions.map { |reaction| reaction.out[0] }.each(&block)
  end
  def tsort_each_child(node, &block)
    reaction = @reactions_by_elem[node]
    reaction.ins.map { |(a,b)| a }.each(&block) if reaction
  end
  def ore_to_fuel(max)
    cost = find("FUEL").ore_for(1)
    upper = max / cost * 2
    lower = max / cost
    while (upper-lower).abs > 1
      guess = (upper + lower) / 2
      used = find("FUEL").ore_for(guess)
      lower = guess if (max - used > 0)
      upper = guess if (max - used < 0)
    end
    lower
  end
end

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

assert_eq Factory.new("sample1.txt").find("FUEL").ore_for(1), 31
assert_eq Factory.new("sample2.txt").find("FUEL").ore_for(1), 165
assert_eq Factory.new("sample3.txt").find("FUEL").ore_for(1), 13312
assert_eq Factory.new("sample4.txt").find("FUEL").ore_for(1), 180697
assert_eq Factory.new("sample5.txt").find("FUEL").ore_for(1), 2210736
# assert solution for step 1
assert_eq Factory.new("reactions.txt").find("FUEL").ore_for(1), 485720
# assert for multiple
assert_eq Factory.new("sample1.txt").find("FUEL").ore_for(5), 145

assert_eq Factory.new("sample3.txt").ore_to_fuel(1000000000000), 82892753
assert_eq Factory.new("sample4.txt").ore_to_fuel(1000000000000), 5586022
assert_eq Factory.new("sample5.txt").ore_to_fuel(1000000000000), 460664
# assert solution for step 2
assert_eq Factory.new("reactions.txt").ore_to_fuel(1000000000000), 3848998
