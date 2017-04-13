require 'gbm_node'

class GbmDecisionTree
  attr_reader :root

  def initialize(tree_xml)
    @id = tree_xml.attribute('id')
    @root = GbmNode.new(tree_xml.xpath('TreeModel/Node'))
  end

  def decide(features)
    curr = @root
    while curr.score.nil?
      prev = curr
      curr = step(curr, features)
      return if didnt_step?(curr, prev)
    end

    curr.score
  end

  private

  def step(curr, features)
    curr = curr.left if curr.left && curr.left.true?(features)
    curr = curr.right if curr.right && curr.right.true?(features)
    curr = curr.missing if curr.missing && curr.missing.true?(features)
    curr
  end

  def didnt_step?(curr, prev)
    return false if (prev.pred != curr.pred)
    RandomForester.logger.error "Null tree: #{@id}, bad feature: #{curr.left.pred.field }"
    true
  end
  
end