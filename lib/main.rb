module MergeSort
  def merge_sort(array)
    return array unless array.size > 1

    mid = array.size / 2
    a = merge_sort(array[0...mid])
    b = merge_sort(array[mid..-1])
    sorted = []
    sorted << (a[0] < b[0] ? a.shift : b.shift) while [a, b].none?(&:empty?)
    sorted + a + b
  end
end

class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def <=>(other)
    value <=> other&.value
  end
end

class Tree
  include MergeSort
  attr_accessor :root, :sorted_array

  def initialize(array)
    @sorted_array = merge_sort(array).uniq
    @root = build_tree(@sorted_array)
  end

  def build_tree(array, start = 0, finish = array.length - 1)
    return nil if start > finish

    mid = (start + finish) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, finish)
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  alias pp pretty_print

  def insert(value, node = @root)
    return node = Node.new(value) if node.nil?

    if value < node.value
      node.left = insert(value, node.left)
    elsif value > node.value
      node.right = insert(value, node.right)
    end
    node
  end

  def minimum(node)
    min = node.value
    until node.left.nil?
      min = node.left.value
      node = node.left
    end
    min
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.value
      node.left = delete(value, node.left)
    elsif value > node.value
      node.right = delete(value, node.right)
    else
      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      end

      node.value = minimum(node.right)
      node.right = delete(node.right, node.value)
    end
    node
  end

  def find(value, node = @root)
    return node if node.nil? || node.value == value 
    return find(value, node.right) if node.value < value

    find(value, node.left)
  end

  def level_order
    queue = [@root]
    return nil if @root.nil?
    return @sorted_array unless block_given?

    until queue.empty?
      node = queue.shift
      yield node
      queue.append(node.left) if node.left
      queue.append(node.right) if node.right
    end
  end

  def inorder(node = @root, output = [], &block)
    return if node.nil?

    inorder(node.left, output, &block)
    output.push(block_given? ? block.call(node) : node.value)
    inorder(node.right, output, &block)

    output
  end

  def preorder(node = @root, output = [], &block)
    return if node.nil?

    output.push(block_given? ? block.call(node) : node.value)
    preorder(node.left, output, &block)
    preorder(node.right, output, &block)

    output
  end

  def postorder(node = @root, output = [], &block)
    return if node.nil?

    postorder(node.left, output, &block)
    postorder(node.right, output, &block)
    output.push(block_given? ? block.call(node) : node.value)

    output
  end

  def height(node = @root, distance = -1)
    return distance if node.nil?

    distance += 1
    [height(node.left, distance), height(node.right, distance)].max
  end

  def depth(value, node = @root)
    return nil if node.nil?

    distance = 0
    until node.value == value
      distance += 1
      node = node.left if value < node.value
      node = node.right if value > node.value
    end

    distance
  end

  def balanced?
    left_subtree = height(@root.left, 0)
    right_subtree = height(@root.right, 0)
    (left_subtree - right_subtree).between?(-1, 1)
  end

  def rebalance!
    @sorted_array = inorder
    @root = build_tree(@sorted_array)
  end
end

test_tree = Tree.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
test_tree.insert(11)
test_tree.insert(12)
test_tree.insert(13)
test_tree.insert(14)

test_tree.pretty_print

puts test_tree.balanced?
test_tree.rebalance!
test_tree.pp