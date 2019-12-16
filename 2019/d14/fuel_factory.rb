class Factor < Struct.new(:quantity, :element)
  def initialize(quantity, element)
    super
  end
  def times(amount)
    Factor.new(quantity*amount, element)
  end
  def leftover(amount)
    Factor.new(amount, element)
  end
  def self.parse(factor)
    quantity, element = factor.split(" ")
    Factor.new(quantity.to_i, element)
  end
  def to_s
    "#{quantity} #{element}"
  end
end

class Formula
  attr_accessor :inputs, :output, :leftover
  def initialize(inputs, output, formulas_by_output, leftover = [])
    @inputs = inputs
    @output = output
    @leftover = leftover
    @formulas_by_output = formulas_by_output
  end
  def rewrite()
    loop do
      rewritten = false
      @inputs = Formula::summarize(@inputs.map do |input|
          formula = @formulas_by_output[input.element]
          if formula && input.quantity % formula.output.quantity == 0
            rewritten = true
            formula.inputs_times(input.quantity / formula.output.quantity)
          else
            input
          end
        end)
      break if rewritten == false
    end
    # puts self.to_s
    self
  end
  def react()
    # puts "react"
    # puts self.to_s
    rewrite
    loop do
      reacted = false
      @inputs.each do |input|
        formula = @formulas_by_output[input.element]
        next unless formula

        leftover = @leftover.find { |left| left.element == input.element }
        net_quantity = input.quantity - leftover&.quantity.to_i
        next if net_quantity < 0

        reacted = true
        times = net_quantity / formula.output.quantity + (net_quantity % formula.output.quantity != 0 ? 1 : 0)

        # puts "react!: #{input} <=  #{times} x #{formula} [#{net_quantity} in #{formula.output.quantity}]"
        @inputs = Formula::summarize((@inputs - [input] + formula.inputs_times(times)))

        leftover_quantity = times * formula.output.quantity - net_quantity
        if leftover_quantity > 0
          if leftover
            leftover.quantity = leftover_quantity
          else
            leftover = input.leftover(leftover_quantity)
            @leftover = Formula::summarize(@leftover << leftover)
          end
        else
          if leftover
            @leftover = @leftover - [leftover]
          end
        end

        break
        # else
        # end
      end
      break if reacted == false
      rewrite
    end
    # puts self.to_s
    self
  end
  def self.summarize(term)
    term
      .flatten
      .group_by(&:element)
      .map { |element, factors| Factor.new(factors.map(&:quantity).sum, element )}
  end
  def times(amount)
    Formula.new(inputs_times(amount), output_times(amount), @formulas_by_output, leftover_times(amount))
  end
  def inputs_times(amount)
    inputs.map { |input| input.times(amount) }
  end
  def output_times(amount)
    output.times(amount)
  end
  def leftover_times(amount)
    leftover.map { |input| input.times(amount) }
  end
  def reuse
    @inputs = Formula::summarize(@inputs + @leftover)
    leftover.clear
  end
  def add_leftover(leftover)
    @inputs = Formula::summarize(@inputs.concat(leftover))
  end
  def to_s
    "#{@inputs.join(", ")} => #{[[@output] + @leftover].join(", ")}"
  end
  def self.parse(row, formulas_by_output)
    inputs, outputs = row.split("=>").map { |termStr| termStr.strip.split(",").map { |input| Factor::parse(input.strip) } }
    Formula.new(inputs, outputs.first, formulas_by_output)
  end
end

class Formulas
  attr_reader :formulas_by_output
  def initialize(filename)
    @formulas_by_output = {}
    File.readlines(filename)
      .map { |row| Formula::parse(row, @formulas_by_output) }
      .map { |formula| @formulas_by_output[formula.output.element] = formula }
  end
  def formulas
    formulas_by_output.values
  end
  def rewrite(element)
    formulas_by_output[element].rewrite
  end
end

# book = Formulas.new("sample1.txt")
# puts book.rewrite("FUEL").react
# puts

# book = Formulas.new("sample2.txt")
# puts book.rewrite("FUEL").react
# puts

# book = Formulas.new("sample3.txt")
# puts book.rewrite("FUEL").react
# puts

# book = Formulas.new("sample4.txt")
# puts book.rewrite("FUEL").react
# puts

# book = Formulas.new("sample5.txt")
# puts book.rewrite("FUEL").react
# puts

# book = Formulas.new("reactions.txt")
# puts book.rewrite("FUEL").react.react
# puts


def ore_to_fuel(filename)

  book = Formulas.new(filename)
  formula = book.rewrite("FUEL").react.react
  puts "###############"*10
  puts formula
  puts "###############"*10
  puts

  stock = 1000000000000
  fuel_produced = 0
  # leftover = []
  # other_inputs = []
  1000.times do |index|

    puts "STOCK: #{stock}"
    # produce the maximum batch
    quantity =  stock / formula.inputs.first.quantity
    used = quantity * formula.inputs.first.quantity
    left = stock - used

    fuel_produced += quantity # derived.output.quantity
    puts "FUEL @#{index} #{fuel_produced}"

    derived = formula.times(quantity)
    # puts "times **** #{derived}"
    # derived.add_leftover(leftover)
    # derived.add_leftover(other_inputs)
    # puts "withlo *** #{derived}"
    puts "react **** #{derived}"

    # # calculate the actual amount of ORE left using the leftovers
    derived.inputs.first.quantity = left
    derived.output.quantity = 0
    derived.reuse
    derived.react.react.react.react
    puts "next1 **** #{derived}"

    # other_inputs = derived.inputs.reject { |i| i.element == "ORE" }
    # leftover = derived.leftover
    stock = derived.inputs.first.quantity
    break if stock < formula.inputs.first.quantity
    puts
    puts
  end
  puts
  puts "FUEL #{fuel_produced}"
end

ore_to_fuel("reactions.txt")
