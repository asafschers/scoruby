# frozen_string_literal: true

module Scoruby
  module Models
    module RandomForest
      RF_FOREST_XPATH = 'PMML/MiningModel/Segmentation/Segment'
      
      class Data
        def initialize(xml)
          @xml = xml
        end

        def decision_trees
          @xml.xpath(RF_FOREST_XPATH).map do |xml_tree|
            DecisionTree.new(xml_tree)
          end
        end
      end
    end
  end
end
