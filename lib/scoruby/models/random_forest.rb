# frozen_string_literal: true

module Scoruby
  module Models
    class RandomForest
      RF_FOREST_XPATH = 'PMML/MiningModel/Segmentation/Segment'

      def initialize(xml)
        xml_trees       = xml.xpath(RF_FOREST_XPATH)
        @decision_trees = xml_trees.map do |xml_tree|
          DecisionTree.new(xml_tree)
        end
      end

      def predict(features)
        decisions_count = decisions_count(features)
        decision = decisions_count.max_by { |_, v| v }
        {
          label: decision[0],
          score: decision[1] / decisions_count.values.reduce(0, :+).to_f
        }
      end

      def decisions_count(features)
        formatted_features = Features.new(features).formatted
        decisions = traverse_trees(formatted_features)
        aggregate_decisions(decisions)
      end

      private

      def traverse_trees(formatted_features)
        @decision_trees.map do |decision_tree|
          decision_tree.decide(formatted_features).score
        end
      end

      def aggregate_decisions(decisions)
        decisions.each_with_object(Hash.new(0)) do |score, counts|
          counts[score] += 1
        end
      end
    end
  end
end
