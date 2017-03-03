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

  def decide(features)
    curr = @root
    while curr.content.decision == ''
      prev = curr
      curr = step(curr, features)
      return if didnt_step?(curr, prev)
    end

    curr.content.decision
  end

  private

  def set_node(tree_xml, root)
    root.content = Predicate.new(tree_xml)
    children = tree_xml.xpath('*')
    return if children.count == 1

    root << Tree::TreeNode.new(LEFT)
    root << Tree::TreeNode.new(RIGHT)

    set_node(children[1], root[LEFT]) if children[1]
    set_node(children[2], root[RIGHT]) if children[2]
  end

  def step(curr, features)
    curr = curr[LEFT] if curr[LEFT] && curr[LEFT].content.true?(features)
    curr = curr[RIGHT] if curr[RIGHT] && curr[RIGHT].content.true?(features)
    curr
  end

  def didnt_step?(curr, prev)
    return false if (prev.content != curr.content)
    RandomForester.logger.error "Null tree: #{@id}, bad feature: #{curr[LEFT].content.field }"
    true
  end

end