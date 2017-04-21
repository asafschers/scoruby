require 'node'

class DecisionTree

  attr_reader :root

  def initialize(tree_xml)
    @id = tree_xml.attribute('id')
    @root = Node.new(tree_xml.xpath('TreeModel/Node'))
  end

  def decide(features)
    curr = @root
    while curr.decision == ''
      prev = curr
      curr = step(curr, features)
      return if didnt_step?(curr, prev)
    end

    curr.decision
  end

  private

  def step(curr, features)
    curr = curr.left if curr.left && curr.left.true?(features)
    curr = curr.right if curr.right && curr.right.true?(features)
    curr
  end

  def didnt_step?(curr, prev)
    return false if (prev.pred != curr.pred)
    Scoruby.logger.error "Null tree: #{@id}, bad feature: #{curr.left.pred.field }"
    true
  end
end