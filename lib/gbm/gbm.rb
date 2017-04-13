require 'gbm_decision_tree'

class Gbm
  GBM_FOREST_XPATH = '//Segmentation[@multipleModelMethod="sum"]/Segment'

  def initialize(xml)
    xml_trees = xml.xpath(GBM_FOREST_XPATH)
    @decision_trees = xml_trees.collect{ |xml_tree|
      GbmDecisionTree.new(xml_tree)
    }
  end

  def tree_count
    @decision_trees.count
  end

  def score(features)
    
  end
end