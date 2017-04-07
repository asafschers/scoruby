require 'gbm_decision_tree'

class Gbm
  GBM_FOREST_XPATH = '//Segmentation[@multipleModelMethod="sum"]/Segment'

  def initialize(xml)
    @xml_trees = xml.xpath(GBM_FOREST_XPATH)
  end

  def tree_count
    @xml_trees.count
  end

  def score(features)

  end

end