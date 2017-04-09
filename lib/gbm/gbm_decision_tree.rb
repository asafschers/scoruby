require 'gbm_node'

class GbmDecisionTree
  attr_reader :root

  def initialize(tree_xml)
    @id = tree_xml.attribute('id')
    @root = GbmNode.new(tree_xml.xpath('TreeModel/Node'))
  end
  
end