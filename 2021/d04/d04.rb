# input = File.read('test.txt')
input = File.read('input.txt')

sections = input.split("\n\n")
numbers = sections[0].strip.split(',').map(&:to_i)

class Board
  def initialize(board)
    @board = Hash[
      board.each_with_index.map do |row,i|
        row.each_with_index.map { |val,j| [val, [i,j]] }
      end.flatten(1)
    ] # turn board into hash that maps values to coordinates to avoid scanning
    rows_count = board.count
    cols_count = board[0].count
    @status_rows = [cols_count] * rows_count
    @status_cols = [rows_count] * cols_count
  end

  def bingo?
    @status_cols.include?(0) ||
    @status_rows.include?(0)
  end

  def play(n)
    row, col = @board[n]
    if row && col
      @board.delete(n) # remove the number from the board
      @status_rows[row] -= 1 # update the rows count
      @status_cols[col] -= 1 # update the cols count
      @board.keys.sum * n if bingo?
    end
  end
end

def play(numbers, boards)
  numbers.product(boards).each do |n, board|
    if score = board.play(n)
      return score
    end
  end
end

# this can be written as a method with a return
def until_the_end(numbers, boards)
  winning = []
  numbers.product(boards) do |n, board|
    if !winning.include?(board) && score = board.play(n)
      if winning.length < boards.length-1
        winning << board
      else
        return score
      end
    end
  end
end

boardsAsArr = sections[1..].map do |block|
  block.split("\n").map { |row| row.split(" ").map(&:to_i) }
end

# initialize boards
boards = boardsAsArr.map { |boardAsArr| Board.new(boardAsArr) }
puts play(numbers, boards)

# initialize boards
boards = boardsAsArr.map { |boardAsArr| Board.new(boardAsArr) }
puts until_the_end(numbers, boards)
