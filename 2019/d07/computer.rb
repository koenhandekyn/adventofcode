class Computer
  def initialize(ram)
    @rom = ram
    reset
  end

  def read
    val = @ram[@pos]
    @pos += 1
    val     
  end

  def readVal(mode)
    mode == 0 ? @ram[read] : read 
  end

  def reset
    @ram = @rom.dup
    @pos = 0
    self
  end

  def runWithInputs(inputs)
    inputQueue = Queue.new
    outputQueue = Queue.new
    inputs.each { |i| inputQueue << i }
    reset.run(inputQueue, outputQueue) 
    outputQueue.pop    
  end

  def run(inputs, outputs)
    loop do
      instruction = read.to_s.rjust(5, "0")
      opcode = instruction[-2..-1].to_i
      mode = instruction[0..-3].split("").map(&:to_i).reverse
      case opcode
      when 1
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        @ram[r] = a + b
      when 2
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        @ram[r] = a * b
      when 3
        a = read
        @ram[a] = inputs.pop.to_i
      when 4
        a = readVal(mode[0])
        outputs << a
      when 5
        a, b = [readVal(mode[0]), readVal(mode[1])]
        @pos = b if a > 0
      when 6
        a, b = [readVal(mode[0]), readVal(mode[1])]
        @pos = b if a == 0
      when 7
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        @ram[r] = a < b ? 1 : 0
      when 8
        a, b, r = [readVal(mode[0]), readVal(mode[1]), read]
        @ram[r] = a == b ? 1 : 0
      when 99
        break
      else
        raise "unexpected opcode #{opcode}"
      end
    end
  end
end