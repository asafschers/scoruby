require 'predicate'
require 'rubytree'

class DecisionTree
  ROOT = 'root'
  LEFT = 'left'
  RIGHT = 'right'

  attr_reader :root

  def initialize(tree_xml)
    @root = Tree::TreeNode.new(ROOT)
    set_node(tree_xml.xpath('TreeModel/Node'), @root)
  end

  def set_node(tree_xml, root)
    root.content = Predicate.new(tree_xml)

    return if tree_xml.xpath('*').count == 1

    root << Tree::TreeNode.new(LEFT)
    root << Tree::TreeNode.new(RIGHT)

    set_node(tree_xml.xpath('*')[1], root[LEFT]) if tree_xml.xpath('*')[1]
    set_node(tree_xml.xpath('*')[2], root[RIGHT]) if tree_xml.xpath('*')[2]
  end

  def decide(features)
    curr = @root
    while curr.children.count > 0
      curr = curr.content.true?(features) ? curr[LEFT] : curr[RIGHT]
    end
    curr.content.decision
  end

end