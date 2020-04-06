require "byebug"

require_relative 'tic_tac_toe'

class TicTacToeNode

  attr_accessor :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end
  
  def children
    children = []
    # debugger

    # Generates a set of children for the current node
    (0...3).each do |row|
      (0...3).each do |col|
        pos = [row, col]

        if self.board.empty?(pos)
          child_board = self.board.dup # Does this work to duplicate the board instance?
          child_board[pos] = self.next_mover_mark
          
          # Create a new node that stores this child_board, plus the updated next_mover_mark and updated prev_move_pos
          child_next_mover_mark = (self.next_mover_mark == :o ? :x : :o)

          child_node = TicTacToeNode.new(child_board, child_next_mover_mark, pos)

          children << child_node
        end
      end
    end

    children
  end

  def losing_node?(evaluator) # Is evaluator "us"?
    if self.board.over? # Base case
      if self.board.winner == evaluator || self.board.winner.nil?
        false
      else
        true
      end
    elsif evaluator == self.next_mover_mark # Recursive case: it is the player's turn
      self.children.all? { |child| child.losing_node?(evaluator) }
    else # Recursive case: it is the opponent's turn
      self.children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    if self.board.over? # Base case
      if self.board.winner == evaluator
        true
      else
        false
      end
    elsif evaluator == self.next_mover_mark # Recursive case: it is the player's turn
      self.children.any? { |child| child.winning_node?(evaluator) }
    else # Recursive case: it is the opponent's turn
      self.children.all? { |child| child.winning_node?(evaluator) }
    end
  end

end
