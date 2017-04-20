require 'gbm_decision_tree'

class Gbm
  GBM_FOREST_XPATH = '//Segmentation[@multipleModelMethod="sum"]/Segment'
  CONST_XPATH      = '//Constant[@dataType="double"]'

  def initialize(xml)
    @decision_trees = xml.xpath(GBM_FOREST_XPATH).collect{ |xml_tree|
      GbmDecisionTree.new(xml_tree)
    }
    @const = Float(xml.xpath(CONST_XPATH).children[0].content)
  end

  def tree_count
    @decision_trees.count
  end

  def score(features)
    @decision_trees.map { |dt| dt.decide(features) }.reduce(:+) + @const


    # TODO: add const and run exp(a) / (1+exp(a))
  end
end