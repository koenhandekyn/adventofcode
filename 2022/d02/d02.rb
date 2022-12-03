#  A/X ROCK, B/Y PAPER, C/Z SCISSORS

SCORE_SHAPE = {
     X: 1, Y: 2, Z: 3 
}

SCORE_WIN = { 
    [:A, :Z] => 0, [:B, :X] => 0, [:C, :Y] => 0,
    [:A, :X] => 3, [:B, :Y] => 3, [:C, :Z] => 3,
    [:A, :Y] => 6, [:B, :Z] => 6, [:C, :X] => 6,
}

def score(p1, p2) = SCORE_SHAPE[p2] + SCORE_WIN[[p1,p2]]

rounds =
    File
        .readlines('input.txt', chomp: true)
        .map { |s| s.split(" ").map(&:to_sym) }

total = 
    rounds
        .map { |p1, p2| score(p1, p2)}
        .sum

puts total

TARGET = { 
    [:A, :X] => :Z, [:B, :X] => :X, [:C, :X] => :Y, # loose 
    [:A, :Y] => :X, [:B, :Y] => :Y, [:C, :Y] => :Z, # draw
    [:A, :Z] => :Y, [:B, :Z] => :Z, [:C, :Z] => :X, # win
}

total =
    rounds
        .map { |p1, p2| [p1, TARGET[[p1, p2]]] }
        .map { |p1, p2| score(p1, p2)}
        .sum        

puts total