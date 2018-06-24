# frozen_string_literal: true

module Scoruby
  module Models
    module RandomForest
      class Data
        RF_FOREST_XPATH = 'PMML/MiningModel/Segmentation/Segment'
        FEATURES_XPATH = 'PMML/DataDictionary/DataField'

        def initialize(xml)
          @xml = xml
        end

        def decision_trees
          @decision_trees ||= @xml.xpath(RF_FOREST_XPATH).map do |xml_tree|
            DecisionTree.new(xml_tree)
          end
        end

        def categorical_features
          @categorical_features ||= fetch_categorical_features
        end

        def continuous_features
          @continuous_features ||= fetch_continuous_features
        end

        def regression?
          @xml.xpath("//MiningModel[@functionName='regression']").any?
        end

        private

        def fetch_continuous_features
          continuous_predicates.map do |xml|
            Predicates::SimplePredicate.new(xml).field
          end.uniq
        end

        def fetch_categorical_features
          categorical_predicates.each_with_object(Hash.new([])) do |xml, res|
            predicate = Predicates::SimpleSetPredicate.new(xml)
            res[predicate.field] = res[predicate.field] | predicate.array
          end
        end

        def categorical_predicates
          @xml.xpath('//SimpleSetPredicate')
        end

        def continuous_predicates
          @xml.xpath('//SimplePredicate')
        end
      end
    end
  end
end
