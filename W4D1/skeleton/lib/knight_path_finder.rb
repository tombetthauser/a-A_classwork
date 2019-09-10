require_relative "tree_node"
require "thread"
require "set"


class KnightPathFinder
  KNIGHT_MOVES = [[1, 2], [1, -2], [-1, 2], [-1, -2], 
                    [2, 1], [2, -1], [-2, 1], [-2, -1]]

  attr_reader :path_tree

  def initialize(start_pos)
    @start_pos = start_pos
    @board_size = 8
    @path_tree = self.build_moves_tree
  end

  def next_valid_moves(curr_pos, visited)
    new_pos_arr = []
    curr_x, curr_y = curr_pos

    KNIGHT_MOVES.each do |move|
      move_x, move_y = move
      possible_pos = [(curr_x + move_x), (curr_y + move_y)]

      new_pos_arr << possible_pos if on_board?(possible_pos) && !visited.include?(possible_pos)
    end

    new_pos_arr
  end

  def on_board?(pos)
    x, y = pos
    x >= 0 && x < 8 && y >= 0 && y < 8
  end

  def build_moves_tree
    # BFS style
    root = PolyTreeNode.new(@start_pos)
    queue = Queue.new.enq(root)
    visited = Set.new

    until queue.empty?
      curr_node = queue.deq
      visited.add(curr_node.value)

      next_moves = next_valid_moves(curr_node.value, visited)

      curr_node.children = next_moves.map { |move| PolyTreeNode.new(move) }
      curr_node.children.each { |child| queue.enq(child) }
    end

    root
  end

  # def find_path(end_pos)
  #   # DFS
  #   # case of base
  #   val = @path_tree.value 
  #   return [val] if val == end_pos

  #   # recursive case 
  #   self.children.each do |child|
  #     child_value = child.find_path(end_pos)

  #     unless child_value.nil?
  #       [val] + child_value
  #     end
  #   end
    
  #   nil
  # end

  # def find_path(end_pos)
  #   # DFS
  #   # case of base
  #   return [@curr_node.value] if @curr_node.value == end_pos

  #   # recursive case 
  #   @curr_node.children.each do |child|

  #     @curr_node = child
  #     child_return = self.find_path(end_pos)

  #     unless child_return.nil?
  #       [@curr_node.value] + child_return
  #     end
  #   end
    
  #   nil
  # end

  def find_path(end_pos)
    @path_tree.dfs_with_traceback(end_pos)
  end
  
end


test = KnightPathFinder.new([0,0])

p test.find_path([4,4])