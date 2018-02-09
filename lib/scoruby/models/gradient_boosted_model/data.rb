# frozen_string_literal: true

module Scoruby
  module Models
    module GradientBoostedModel
      class Data
        GBM_FOREST_XPATH = '//Segmentation[@multipleModelMethod="sum"]/Segment'
        CONST_XPATH      = '//Target/@rescaleConstant'
        CONST_XPATH_4_2  = '//Constant'

        def initialize(xml)
          @xml = xml
        end

        def decision_trees
          @decision_trees ||= @xml.xpath(GBM_FOREST_XPATH).map do |xml_tree|
            DecisionTree.new(xml_tree)
          end
        end

        def const
          @const ||= const_by_version
        end

        def continuous_features
          @continuous_features ||= fetch_continuous_features
        end

        def categorical_features
          @categorical_features ||= fetch_categorical_features
        end

        private

        def fetch_continuous_features
          @xml.xpath('//DataField')
              .select { |xml| xml.attr('optype') == 'continuous' }
              .map { |xml| xml.attr('name').to_sym }
        end

        def fetch_categorical_features
          @xml.xpath('//DataField')
              .select { |xml| xml.attr('optype') == 'categorical' }
              .reject { |xml| xml.attr('name') == target }
              .each_with_object(Hash.new([])) do |xml, res|
            res[xml.attr('name').to_sym] = xml.xpath('Value')
                                              .map { |xml| xml.attr('value') }
          end
        end

        def target
          @target ||= @xml.xpath('//MiningField')
                          .find { |xml| xml.attr('usageType') == 'target' }
                          .attr('name').to_s
        end

        def const_by_version
          return Float(@xml.xpath(CONST_XPATH).to_s) if ModelFactory.gbm_4_3?(@xml)
          Float(@xml.xpath(CONST_XPATH_4_2).first.content)
        end
      end
    end
  end
end
