# Node class with an attribute for data as well as left and right children
class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child

  def initialize(value, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(other)
    @value <=> other.value
  end
end

# Merge sorting algorithm
module MergeSort
  def merge_sort(array)
    return array unless array.size > 1

    mid = array.size/2
    a, b, sorted = merge_sort(array[0...mid]), merge_sort(array[mid..-1]), []
    sorted << (a[0] < b[0] ? a.shift : b.shift) while [a,b].none?(&:empty?)
    sorted + a + b
  end
end

# Tree is a rooted binary tree data structure
class Tree
  include MergeSort
  attr_accessor :array, :processed_array, :root

  def initialize(array)
    @array = array
    @processed_array = merge_sort(array).uniq!
    @root = build_tree(@processed_array)
  end
  # e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

  def build_tree(array, start = 0, stop = array.length - 1)
    return nil if start > stop
    
    mid = (start + stop) / 2;
    root = Node.new(array[mid])
    root.left_child = build_tree(array, start, mid - 1)
    root.right_child = build_tree(array, mid + 1, stop)

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  def insert(root, value)
    return nil if @processed_array.include?(value)
    return root = Node.new(value) if root.nil?

    if root.value < value
      root.right_child = insert(root.right_child, value)
    else
      root.left_child = insert(root.left_child, value)
    end
    root
  end

  def delete(root, value)
    return root if root.nil?

    if root.value < value
      root.right_child = delete(root.right_child, value)
    elsif root.value > value
      root.left_child = delete(root.left_child, value)
    else
      if root.left_child.nil?
        return root.right_child
      elsif root.right_child.nil?
        return root.left_child
      end
      root.value = minimum(root.right_child)
      root.right_child = delete(root.right_child, root.value)
    end
    root
  end 

  def minimum(root)
    minimum_value = root.value
    until root.left_child.nil?
      minimum_value = root.left_child.value
      root = root.left_child
    end
    minimum_value
  end
end

test_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
puts test_tree.root.value
puts test_tree.array.to_s
puts test_tree.processed_array.to_s
puts test_tree.pretty_print
test_tree.insert(test_tree.root, 2)
test_tree.insert(test_tree.root, 1)
puts test_tree.pretty_print
test_tree.delete(test_tree.root, 8)
puts test_tree.pretty_print