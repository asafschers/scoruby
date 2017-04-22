require 'decision_tree'
require 'features'

class Gbm
  GBM_FOREST_XPATH = '//Segmentation[@multipleModelMethod="sum"]/Segment'
  CONST_XPATH      = '//Constant[@dataType="double"]'

  def initialize(xml)
    @decision_trees = xml.xpath(GBM_FOREST_XPATH).collect{ |xml_tree|
      DecisionTree.new(xml_tree)
    }
    @const = Float(xml.xpath(CONST_XPATH).children[0].content)
  end

  def tree_count
    @decision_trees.count
  end

  def score(features)
    formatted_features = Features.new(features).formatted
    x = @decision_trees.map { |dt|
      score = dt.decide(formatted_features)
      score.to_s.to_f
    }.reduce(:+) + @const
    Math.exp(x) / (1 + Math.exp(x))
  end

end

