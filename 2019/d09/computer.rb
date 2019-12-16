require 'csv'
class Computer
  attr_reader :rom
  def initialize(ram, debug: false)
    @debug = debug
    @rom = ram
    reset
  end

  def read
    val = @ram[@pos] || 0
    @pos += 1
    val
  end

  def readVal(mode)
    case mode
    when 0
      @ram[read] || 0
    when 1
      read
    when 2
      @ram[@relbase+read] || 0
    end
  end

  def writeVal(mode, address, val)
    case mode
    when 0
      puts "@ram[#{address}] = #{val}" if @debug
      @ram[address] = val
    # when 1
    #   puts "outputs << #{val}" if @debug
    #   outputs << val
    when 2
      puts "@ram[#{@relbase + address}] = #{val}" if @debug
      @ram[@relbase + address] = val
    end
  end

  def reset
    @ram = @rom.dup
    @pos = 0
    @relbase = 0
    self
  end

  def runWithArray(inputs)
    inputQueue = Queue.new
    inputs.each { |i| inputQueue << i }
    outputQueue = Queue.new
    run(inputQueue, outputQueue)
    Array.new(outputQueue.size) { outputQueue.pop }
  end

  def run(inputs, outputs)
    loop do
      instruction = read.to_s.rjust(5, "0")
      opcode = instruction[-2..-1].to_i
      mode = instruction[0..-3].split("").map(&:to_i).reverse
      puts "instruction: #{instruction}, opcode: #{opcode}, mode: #{mode.to_s}, pos: #{@pos}, relbase: #{@relbase}" if @debug
      case opcode
      when 1
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        puts "#{a} + #{b}" if @debug
        writeVal(mode[2], r, a  + b)
      when 2
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        puts "#{a} * #{b}" if @debug
        writeVal(mode[2], r, a  * b)
      when 3
        r = read
        puts "read input to #{r}/#{mode[0]}" if @debug
        writeVal(mode[0], r, inputs.pop.to_i)
      when 4
        a = readVal(mode[0])
        puts "write output #{a}" if @debug
        outputs << a
      when 5
        a, b = [readVal(mode[0]), readVal(mode[1])]
        puts "goto #{b} if #{a} > 0" if @debug
        @pos = b if a > 0
      when 6
        a, b = [readVal(mode[0]), readVal(mode[1])]
        puts "goto #{b} if #{a} == 0" if @debug
        @pos = b if a == 0
      when 7
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        puts "write : #{a} < #{b} ? 1 : 0" if @debug
        writeVal(mode[2], r, a < b ? 1 : 0)
      when 8
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        puts "write : #{a} == #{b} ? 1 : 0" if @debug
        writeVal(mode[2], r, a == b ? 1 : 0)
      when 9
        a = readVal(mode[0])
        puts "relbase += #{a}" if @debug
        @relbase += a
      when 99
        break
      else
        raise "unexpected opcode #{opcode}"
      end
    end
  end

  ##########

  def self.load(filename, debug: false)
    code = CSV.read(filename)[0].map(&:to_i)
    Computer.new(code, debug: debug)
  end
end