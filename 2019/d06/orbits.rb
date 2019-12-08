# orbits.rb

class Space
  def initialize(data)
    @orbits = data.reduce({}) do |orbits, data| 
      a, b = data.split(")") 
      orbits[b] = a
      orbits
    end
  end

  def pathToCom(o, p = [])
    return p if (o == "COM")
    pathToCom(@orbits[o], p << @orbits[o])
  end

  def orbitsCounts
    @orbits.keys.map { |k| pathToCom(k).size }.sum
  end

  def pathFromTo(from, to)
    fromToComPath = pathToCom(@orbits[from])
    toToComPath = pathToCom(to)
    common = fromToComPath & toToComPath
    (fromToComPath - common) + [common.first] + (toToComPath - common).reverse    
  end

  def transfersCount(from, to)
    pathFromTo(from, to).size
  end
end

space = Space.new(File.read("data.txt").split("\n"))
puts space.orbitsCounts
puts space.transfersCount("YOU", "SAN")

####### tests

def assert_eq(v1, v2)
  raise "expected #{v1} == #{v2}" unless v1 == v2
end

space = Space.new(["COM)B","B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L"])
assert_eq space.orbitsCounts, 42

space = Space.new(["COM)B","B)C","C)D","D)E","E)F","B)G","G)H","D)I","E)J","J)K","K)L","K)YOU","I)SAN"])
assert_eq space.transfersCount("YOU", "SAN"), 4

