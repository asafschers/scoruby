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
    curr = curr.children[0] if curr.children && curr.children[0] && curr.children[0].true?(features)
    curr = curr.children[1] if curr.children && curr.children[1] && curr.children[1].true?(features)
    curr = curr.children[2] if curr.children && curr.children[2] && curr.children[2].true?(features)
    curr
  end

  def didnt_step?(curr, prev)
    return false if (prev.pred != curr.pred)
    Scoruby.logger.error "Null tree: #{@id}, bad feature: #{curr.children[0].pred.field }"
    true
  end
end