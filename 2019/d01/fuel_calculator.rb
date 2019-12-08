require 'csv'

masses = CSV.read(File.new('data.csv'), headers: true, converters: :all).by_col['mass']

def fuel_for_mass(mass)
  mass / 3 - 2
end

# imperative
def total_fuel_for_mass(mass)
  total_fuel_for_mass = fuel = fuel_for_mass(mass)
  while (fuel = fuel_for_mass(fuel)) > 0 
  	total_fuel_for_mass += fuel
  end
  total_fuel_for_mass
end

# functional
def total_fuel_recursive(mass)
  fuel = fuel_for_mass(mass) 
  fuel > 0 ? fuel + total_fuel_recursive(fuel) : 0
end

############

puts "read ##{masses.count} masses"

def assert_eq(v1, v2)
	raise "expected #{v1} == #{v2}" unless v1 == v2
end

assert_eq fuel_for_mass(100756), 33583
assert_eq fuel_for_mass(1969), 654

total_fuel = masses.map { |m| fuel_for_mass(m) }.sum

puts "total initial fuel needed is: #{total_fuel}"

assert_eq total_fuel_for_mass(1969), 966
assert_eq total_fuel_for_mass(100756), 50346

assert_eq total_fuel_recursive(1969), 966
assert_eq total_fuel_recursive(100756), 50346

total_fuel_for_mass_and_fuel = masses.map { |m| total_fuel_recursive(m) }.sum

puts "total fuel with fuel for fuel needed is: #{total_fuel_for_mass_and_fuel}"