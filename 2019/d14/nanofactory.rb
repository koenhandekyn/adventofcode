# nanofactory.rb

class Hash
  def map_values
    Hash[ map { |k, v| [k, yield(v)] } ]
  end
end

class Reaction
  attr_accessor :ins, :out
  def initialize(ins, out, factory)
    @ins =
      ins
        .group_by { |elem, _| elem }
        .map { |elem, elems| [elem, elems.map { |_, quantity| quantity}.sum] }
    @out = out
    @factory = factory
  end
  def quantity_for(elem)
    @ins.find { |key, _| key == "ORE" }&.fetch(1)
  end
  def update(elem, quantity)
    elem_quantity = @ins.find { |key, _| key == "ORE" }
    elem_quantity[1] = quantity
    self
  end
  def append(other)
    @ins =
      (@ins + other)
        .group_by { |elem, _| elem }
        .map { |elem, elems| [elem, elems.map { |_, quantity| quantity}.sum] }
    self
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
  def rewrite
    @ins =
      @ins
        .map { |elem, quantity| @factory.expand(elem, quantity) }
        .flatten(1)
        .group_by { |elem, _| elem }
        .map { |elem, elems| [elem, elems.map { |_, quantity| quantity}.sum] }
        .select { |_, quantity| quantity != 0 }
    self
  end
  def to_s
    "#{@ins.map(&:to_s).join(", ")} => #{@out.map(&:to_s)}"
  end
end

class Factory
  attr_reader :reactions
  def initialize(filename)
    @reactions =
      File
        .readlines(filename)
        .map { |row| Reaction::parse(row, self) }
    @reactions_by_elem =
      Hash[ @reactions.map { |r| [r.out[0], r] } ]
  end
  def expand(elem, quantity)
    reaction = @reactions_by_elem[elem]
    if reaction
      if (quantity % reaction.out[1] == 0)
        multiplier = quantity / reaction.out[1]
        @expanded = true if multiplier > 1
        reaction.ins_times(multiplier)
      else
        multiplier = quantity / reaction.out[1] + 1
        leftover = quantity - multiplier * reaction.out[1]
        @expanded = true if multiplier > 0
        reaction.ins_times(multiplier) + [[elem, leftover]]
      end
    else
      [[elem, quantity]]
    end
  end
  def expand_all
    @expanded = true
    while @expanded
      @expanded = false
      @reactions.each { |reaction| reaction.rewrite }
    end
    self
  end
  def find(elem)
    @reactions_by_elem[elem]
  end
  # recursive variant raises stack level to deep error
  def ore_to_fuel(amount)
    fuel_reaction = find("FUEL")
    batch_size = fuel_reaction.quantity_for("ORE")
    batch_leftover = fuel_reaction.ins_times(-1).select { |elem, _| elem != "ORE" }
    leftover = []
    fuel_produced = 0
    reaction = Reaction.new(batch_leftover, [], self)
    while amount > batch_size do
      reaction.append(batch_leftover).rewrite
      new_ore = reaction.quantity_for("ORE").to_i
      puts "#{amount}-#{batch_size}+#{new_ore} => #{fuel_produced}" if fuel_produced % 100000 == 0
      amount = amount - batch_size + new_ore
      reaction.update("ORE", 0)
      # leftover = reaction.ins.select { |elem, _| elem != "ORE" }
      fuel_produced += 1
    end
    puts "FFFF : #{fuel_produced}"
    return fuel_produced
  end
end

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

assert_eq Factory.new("sample3.txt").expand_all.find("FUEL").quantity_for("ORE"), 13312
assert_eq Factory.new("sample4.txt").expand_all.find("FUEL").quantity_for("ORE"), 180697
assert_eq Factory.new("sample5.txt").expand_all.find("FUEL").quantity_for("ORE"), 2210736

# assert solution for step 1
assert_eq Factory.new("reactions.txt").expand_all.find("FUEL").quantity_for("ORE"), 485720
puts Factory.new("reactions.txt").expand_all.find("FUEL")
# exit
# puts Factory.new("reactions.txt").expand_all.ore_to_fuel(1000000000000)

# # puts Factory.new("sample3.txt").expand_all.find("FUEL")
puts "asserting ore_to_fuel for examples"
# assert_eq Factory.new("sample3.txt").expand_all.ore_to_fuel(1000000000000), 82892753
# assert_eq Factory.new("sample4.txt").expand_all.ore_to_fuel(1000000000000), 5586022
assert_eq Factory.new("sample5.txt").expand_all.ore_to_fuel(1000000000000), 460664

