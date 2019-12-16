require 'matrix'

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

class Moon1D
  attr_accessor :pos
  attr_accessor :vel
  def initialize(pos, vel = 0)
    @pos = pos
    @vel = vel
  end
  def step
    @pos += @vel
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
end

module Force1D
  def self.gravity_for_dim(a, b)
    if a.pos < b.pos
      a.vel += 1
      b.vel -= 1
    end
    if a.pos > b.pos
      a.vel -= 1
      b.vel += 1
    end
  end
end

class Universe1D
  def initialize(moons)
    @moons = moons
  end

  def step
    gravity
    velocity
  end

  def times(n)
    n.times { step }
    self
  end

  def gravity
    @moons.combination(2).each { |a,b| Force1D::gravity_for_dim(a, b) }
  end

  def velocity
    @moons.each(&:step)
  end

  def energy
    @moons.map(&:energy).sum
  end

  def wavelength
    i = 0
    states = {}
    loop do
      state = @moons.dup
      return i if states[state]
      states[state] = i
      step
      i += 1
    end
  end

  def to_s
    @moons.map(&:to_s).join("\n")
  end
end

module Universe3D
  def self.wavelength(coords)
    coords
      .transpose
      .map { |c| Moon1D.new(c) }
      .to_a
      .map { |ms| Universe1D.new(ms) }
      .map(&:wavelength)
      .reduce(1, :lcm)
  end
end

wavelength =
  Universe3D.wavelength(
    Matrix[[ -8,-18,  6],
           [-11,-14,  4],
           [  8, -3,-10],
           [ -2,-16,  1]])

puts "repitions: #{wavelength}"

wavelength =
  Universe3D.wavelength(
    Matrix[[-1,  0,  2],
           [ 2,-10, -7],
           [ 4, -8,  8],
           [ 3,  5, -1]])

assert_eq wavelength, 2772

wavelength =
  Universe3D.wavelength(
    Matrix[[-8,-10, 0],
           [ 5,  5,10],
           [ 2, -7, 3],
           [ 9, -8,-3]])

assert_eq wavelength, 4686774924

