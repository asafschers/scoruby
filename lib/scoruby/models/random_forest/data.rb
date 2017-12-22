# frozen_string_literal: true

module Scoruby
  module Models
    module RandomForest
      RF_FOREST_XPATH = 'PMML/MiningModel/Segmentation/Segment'
      FEATURES_XPATH = 'PMML/DataDictionary/DataField'

      class Data
        def initialize(xml)
          @xml = xml
        end

        def decision_trees
          @xml.xpath(RF_FOREST_XPATH).map do |xml_tree|
            DecisionTree.new(xml_tree)
          end
        end

        def continuous_features
          features_by('continuous').map { |feature| feature.attr('name') }
        end

        def categorical_features
          features_by('categorical').map { |feature| feature.attr('name') }
        end

        private

        def features_by(type)
          @xml.xpath(FEATURES_XPATH).select { |fn| fn.attr('optype') == type }
        end
      end
    end
  end
end
