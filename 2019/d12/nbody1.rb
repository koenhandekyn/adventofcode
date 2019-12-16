require 'matrix'

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

class Vector
  def x
    self[0]
  end
  def y
    self[1]
  end
  def z
    self[2]
  end
end

class Moon
  attr_accessor :pos
  attr_accessor :vel
  def initialize(pos, vel = Vector[0,0,0])
    @pos = pos
    @vel = vel
  end
  def step
    @pos += @vel
  end
  def energy_pot
    @pos.x.abs + @pos.y.abs + @pos.z.abs
  end
  def energy_kin
    @vel.x.abs + @vel.y.abs + @vel.z.abs
  end
  def energy
    energy_pot * energy_kin
  end
  def to_s
    "p: #{@pos}, v:#{@vel}"
  end
  def eql?(other)
    @pos == other.pos && vel == other.vel
  end
  def hash
    [@pos,@vel].hash
  end
  def initialize_copy(orig)
    super
  end
  def self.at(x,y,z)
    Moon.new(Vector[x,y,z])
  end
end

module Forces
  def self.gravity_for_dim(a, b, i)
    if a.pos[i] < b.pos[i]
      a.vel[i] += 1
      b.vel[i] -= 1
    end
    if a.pos[i] > b.pos[i]
      a.vel[i] -= 1
      b.vel[i] += 1
    end
  end
end

class Universe
  def initialize(moons)
    @moons = moons
  end

  def step
    gravity
    velocity
  end

  def times(n)
    n.times { step; }
    self
  end

  def gravity
    @moons.combination(2).each do |a,b|
      Forces::gravity_for_dim(a, b, 0)
      Forces::gravity_for_dim(a, b, 1)
      Forces::gravity_for_dim(a, b, 2)
    end
  end

  def velocity
    @moons.each(&:step)
  end

  def energy
    @moons.map(&:energy).sum
  end

  def steps_until_repeat
    i = 0
    states = {}
    loop do
      state = @moons.dup
      return i if states[state]
      states[state] = [i, state]
      step
      i += 1
    end
  end

  def to_s
    @moons.map(&:to_s).join("\n")
  end
end

moons = [ Moon.at( -8,-18,  6),
          Moon.at(-11,-14,  4),
          Moon.at(  8, -3,-10),
          Moon.at( -2,-16,  1) ]

universe = Universe.new(moons).times(1000)
puts "total energy: #{universe.energy}"
# universe = Universe.new(moons)
# puts "total energy: #{universe.steps_until_repeat}"

moons = [ Moon.at(-1,  0,  2),
          Moon.at( 2,-10, -7),
          Moon.at( 4, -8,  8),
          Moon.at( 3,  5, -1) ]

universe = Universe.new(moons).times(10)

assert_eq universe.energy, 179

moons = [ Moon.at(-8,-10, 0),
          Moon.at( 5,  5,10),
          Moon.at( 2, -7, 3),
          Moon.at( 9, -8,-3) ]

universe = Universe.new(moons).times(100)

assert_eq universe.energy, 1940

################## faze 2

moons = [ Moon.at(-1,  0,  2),
          Moon.at( 2,-10, -7),
          Moon.at( 4, -8,  8),
          Moon.at( 3,  5, -1) ]

assert_eq Universe.new(moons).steps_until_repeat, 2772

# # this is to slow

# moons = [ Moon.at(-8,-10, 0),
#           Moon.at( 5,  5,10),
#           Moon.at( 2, -7, 3),
#           Moon.at( 9, -8,-3) ]

# assert_eq Universe.new(moons).steps_until_repeat, 4686774924
