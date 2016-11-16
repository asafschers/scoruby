require 'decision_tree'

class RandomForest
  # TODO: iterate over trees and return score
  # TODO: publish gem

  def initialize(xml)
    @xml = xml
  end

  def predict
    tree_xml = @xml.xpath("PMML/MiningModel/Segmentation/Segment/TreeModel").first.to_s
    DecisionTree.new(tree_xml).decide
  end


end