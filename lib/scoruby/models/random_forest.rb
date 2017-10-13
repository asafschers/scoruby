module Scoruby
  module Models
    class RandomForest
      RF_FOREST_XPATH = 'PMML/MiningModel/Segmentation/Segment'

      def initialize(xml)
        xml_trees       = xml.xpath(RF_FOREST_XPATH)
        @decision_trees = xml_trees.collect {|xml_tree|
          DecisionTree.new(xml_tree)
        }
      end

      def decisions_count(features)
        formatted_features = Features.new(features).formatted
        decisions          = @decision_trees.collect {|decision_tree|
          decision_tree.decide(formatted_features).score
        }
        decisions.inject(Hash.new(0)) {|h, e| h[e] += 1; h}
      end

      def predict(features)
        decisions_count = decisions_count(features)
        {
            label: decisions_count.max_by {|_, v| v}[0],
            score: decisions_count.max_by {|_, v| v}[1] / decisions_count.values.reduce(0, :+).to_f
        }
      end
    end
  end
end