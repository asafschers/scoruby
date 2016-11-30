require 'decision_tree'

class RandomForest

  def initialize(xml)
    xml_trees = xml.xpath("PMML/MiningModel/Segmentation/Segment/TreeModel/Node")
    @decision_trees = xml_trees.collect{ |xml_tree|
      DecisionTree.new(xml_tree)
    }
  end

  def decisions_count(fearures)
    decisions = @decision_trees.collect { |decision_tree|
      decision_tree.decide(fearures)
    }
    decisions.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
  end

  def predict(features)
    decisions_count(features).max_by {|_, v|  v }[0]
  end

end