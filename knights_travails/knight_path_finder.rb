require_relative "00_tree_node.rb"

class KnightPathFinder
    KNIGHT_MOVES = [[1,2], [2,1], [2,-1], [1,-2], [-1,-2], [-2,-1], [-2,1], [-1,2]] # This determines the order that positions are considered

    def self.valid_moves(pos)
        valid_moves = []
        KNIGHT_MOVES.each do |move|
            final_pos = [pos[0] + move[0], pos[1] + move[1]]
            valid_moves << final_pos if final_pos.all? {|coord| coord.between?(0, 7) }
        end
        valid_moves
    end

    attr_reader :root_node, :considered_positions, :start_pos

    def initialize(pos)
        @root_node = PolyTreeNode.new(pos)
        @considered_positions = [pos]
        @start_pos = pos #might not be necessary
        self.build_move_tree
    end

    def new_move_positions(pos)
        possible_moves = KnightPathFinder.valid_moves(pos)
        new_valid_moves = possible_moves.reject {|possible_move| self.considered_positions.include?(possible_move) }
        @considered_positions += new_valid_moves
        new_valid_moves
    end

    ### OK!

    # Seems to be working
    def build_move_tree
        queue = [self.root_node] # queue of nodes

        until queue.empty?
            current_node = queue.shift
            current_pos = current_node.value

            moves_from_here = new_move_positions(current_pos)

            moves_from_here.each do |move| # move is a [x, y]
                new_node = PolyTreeNode.new(move)
                new_node.parent = current_node # Should take care of tree relationship
                queue << new_node
            end
        end
    end

    def find_path(end_pos)
        end_node = self.root_node.bfs(end_pos)
        # p end_node
        self.trace_path_back(end_node)
    end

    def trace_path_back(end_node)
        path = []
        current_node = end_node

        until current_node == nil # current_node == nil
            path << current_node.value
            current_node = current_node.parent
        end

        path.reverse
    end
end

# p KnightPathFinder.valid_moves([0, 7])

kpf = KnightPathFinder.new([0, 0])
p kpf.find_path([7,6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf.find_path([6,2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]

# 1 = [0, 0]
# 2 = [1, 2]
# 3 = [2, 1]
# 4 = [2, 4]
# 5 = [3, 3]
# 6 = [3, 1]
# 7 = [2, 0]
# 8 = [0, 4]
# 9 = [4, 2]
# 10 = [4, 0]
# 11 = [0, 2]
# 12 = [1, 3]

