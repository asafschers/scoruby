require 'decision_tree'

class RandomForest

  def initialize(xml)
    xml_trees = xml.xpath("PMML/MiningModel/Segmentation/Segment/TreeModel/Node")
    @decision_trees = xml_trees.collect{ |xml_tree|
      puts '1'
      DecisionTree.new(xml_tree)
    }
  end

  def predict(features)
    @decision_trees.count { |decision_tree|
      decision_tree.decide(features) == DecisionTree::SHOULD_APPROVE
    }
  end

end