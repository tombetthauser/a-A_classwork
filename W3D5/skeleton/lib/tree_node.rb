require "byebug"
require "thread"

class PolyTreeNode

    attr_accessor :parent, :children, :value

    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def parent=(p_node)
        return @parent = nil if p_node.nil? 
        @parent.remove_child(self) unless @parent.nil?
        p_node.children << self # unless p_node == @parent
        @parent = p_node
    end
    
    def add_child(c_node)
        c_node.parent = self        
        @children = @children | [c_node]        
    end

    def remove_child(c_node)
        raise if c_node.parent.nil?
        c_node.parent = nil
        @children = @children - [c_node]
    end
  

    def dfs(target)
        #base case
        return self if self.value == target 
        
        #recursive case
        self.children.each do |child|
            result = child.dfs(target)
            return result unless result.nil?
        end
        
        nil
    end

    def dfs_with_traceback(target)
        #base case
        return [self.value] if self.value == target 
        
        #recursive case
        self.children.each do |child|
            child_return = child.dfs_with_traceback(target)
            return [self.value] + child_return unless child_return.nil?
        end
        
        nil
    end  

    def bfs(target)
        queue = Queue.new.enq(self)

        until queue.empty?
            curr_node = queue.deq
            return curr_node if curr_node.value == target
            curr_node.children.each { |child| queue.enq(child) }
        end

        nil
    end

    # def inspect
    #     "value: #{@value}"
    # end

end