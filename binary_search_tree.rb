class Node
    attr_accessor :data, :left_node, :right_node

    def initialize(data)
        @data = data
        @left_node = nil
        @right_node = nil
    end
end

class Tree
    attr_accessor :root
    def initialize(arr)
        @root = unique_tree(arr)
    end

    def pretty_print(node = @root, prefix = '', is_left: true)
        return unless node
      
        pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false)
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true)
      end

      def include?(value, node = @root)
        return false if node == nil
        return true if node.data == value

        include?(value, node.right_node) ? value > node.data : include?(value, node.left_node)
      end

      def insert(value, node = @root)
        return if include?(value)
        return if node.data == value
        if node.data < value && node.right_node == nil
            node.right_node = Node.new(value)
            
           
        elsif node.data < value && node.right_node != nil
            
            insert(value, node.right_node)
        elsif node.data > value && node.left_node == nil
            node.left_node = Node.new(value)
            
        elsif node.data > value && node.left_node != nil
            insert(value, node.left_node)
        end
      end

      def getSuccessor(node = @root)
        curr = node.right_node
        
        while curr != nil && curr.left_node != nil
            curr = curr.left_node;
        end

        return curr;
      end

      def delete(value, node = @root)
        return node if node == nil

        if node.data > value
            node.left_node = delete(value, node.left_node)
        elsif node.data < value
            node.right_node = delete(value, node.right_node)
        else 
            if node.left_node == nil
                return node.right_node
            end
            if node.right_node == nil
                return node.left_node
            end

            succ = getSuccessor(node)
            node.data = succ.data
            node.right_node = delete(succ.data, node.right_node)
        end

        return node

        end

        def level_order(queue = [@root], &block)
            return to_enum(:level_order) unless block
            return self if queue.empty?
          
            current_node = queue.shift
          
            yield current_node.data
          
            queue << current_node.left_node if current_node.left_node
            queue << current_node.right_node if current_node.right_node
          
            level_order(queue, &block)
          end

          def pre_order(node = @root, &block)
            return to_enum(:pre_order) unless block
            return self if node.nil?
            yield node.data
            pre_order(node.left_node, &block)
            pre_order(node.right_node, &block)
          end

          def in_order(node = @root, &block)
            return to_enum(:in_order) unless block
            return self if node.nil?
            
            in_order(node.left_node, &block)
            yield node.data
            in_order(node.right_node, &block)
          end

          def post_order(node = @root, &block)
            return to_enum(:post_order) unless block
            return self if node.nil?
            
            post_order(node.left_node, &block)
            post_order(node.right_node, &block)
            yield node.data
          end

          def height(value, node = @root)
                return nil if node == nil
                if node.data == value
                    find_leaf(node)
                elsif node.data < value
                    height(value, node.right_node)
                else
                    height(value, node.left_node)
                end


            end

            def find_leaf(node, h = 0)
                return h - 1 if node == nil

                left_side = find_leaf(node.left_node, h + 1)
                right_side = find_leaf(node.right_node, h + 1)

                if left_side > right_side
                    return left_side
                else
                    return right_side
                end
            end

            def depth(value, node = @root, d = 0)
                return nil if node == nil
                if node.data == value
                    return d 
                elsif node.data < value
                    depth(value, node.right_node, d + 1)
                elsif node.data > value
                    depth(value, node.left_node, d + 1)
                end
            end

            def balanced?(queue = [@root])
                return false if find_balance(queue[0]) == false
                return true if queue.empty?

                current_node = queue.shift
                queue << current_node.left_node if current_node.left_node
                queue << current_node.right_node if current_node.right_node
                
                balanced?(queue)

            end

            def find_balance(node, h = 0)
                return h - 1 if node == nil

                left_side = find_leaf(node.left_node, h + 1)
                right_side = find_leaf(node.right_node, h + 1)

                if left_side - right_side > 1 || right_side - left_side > 1
                    return false
                end
            end

            def rebalance
                new_tree = []
                level_order { |data| new_tree << data }
                @root = unique_tree(new_tree)
            end



private
    def unique_tree(arr)
        arr.uniq!
        build_tree(arr)
    end

    def build_tree(arr, start = 0, last = arr.length - 1)
        return nil if start > last
        
        mid = (start + ((last - start) / 2)).floor
       
        root = Node.new(arr[mid])
    

        root.right_node = build_tree(arr, mid + 1, last)
        root.left_node = build_tree(arr, start, mid -1)

        return root
    end
end

tree = Tree.new((Array.new(15) { rand(1..100) }))
p tree.balanced?
tree.pretty_print
tree.level_order { |data| puts data }
tree.in_order { |data| puts data }
tree.post_order { |data| puts data }
tree.pre_order { |data| puts data }
tree.insert(111)
tree.insert(121)
tree.pretty_print
p tree.balanced?
tree.rebalance
p tree.balanced?
tree.pretty_print
tree.level_order { |data| puts data }
tree.in_order { |data| puts data }
tree.post_order { |data| puts data }
tree.pre_order { |data| puts data }
