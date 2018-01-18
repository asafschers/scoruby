# frozen_string_literal: true

require 'scoruby/models/decision_tree'
require 'scoruby/features'

module Scoruby
  module Models
    class Gbm
      GBM_FOREST_XPATH = '//Segmentation[@multipleModelMethod="sum"]/Segment'
      CONST_XPATH      = '//Target/@rescaleConstant'
      CONST_XPATH_4_2  = '//Constant'

      def initialize(xml)
        @decision_trees = xml.xpath(GBM_FOREST_XPATH).map do |xml_tree|
          DecisionTree.new(xml_tree)
        end
        @const = const(xml)
      end

      def tree_count
        @decision_trees.count
      end

      def score(features)
        formatted_features = Features.new(features).formatted
        scores = @decision_trees.map do |dt|
          dt.decide(formatted_features).score.to_s.to_f
        end
        sum = scores.reduce(:+) + @const
        Math.exp(sum) / (1 + Math.exp(sum))
      end

      private

      def const(xml)
        return Float(xml.xpath(CONST_XPATH).to_s) if ModelFactory.gbm_4_3?(xml)
        Float(xml.xpath(CONST_XPATH_4_2).first.content)
      end
    end
  end
end
