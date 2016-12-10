require 'predicate'
require 'rubytree'

class DecisionTree
  ROOT = 'root'
  LEFT = 'left'
  RIGHT = 'right'

  attr_reader :root

  def initialize(tree_xml)
    @id = tree_xml.xpath('@id')
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
    while curr.content.decision == ''
      prev = curr
      curr = curr[LEFT] if curr[LEFT] && curr[LEFT].content.true?(features)
      curr = curr[RIGHT] if curr[RIGHT] && curr[RIGHT].content.true?(features)

      return if no_true_child?(curr, prev)
    end

    curr.content.decision
  end

  def no_true_child?(curr, prev)
    return false if (prev.content != curr.content)
    RandomForester.logger.error "Null tree: #{@id}, bad feature: #{curr[LEFT].content.field }"
    true
  end

end