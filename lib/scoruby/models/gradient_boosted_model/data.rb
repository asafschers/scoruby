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

        private

        def const_by_version
          return Float(@xml.xpath(CONST_XPATH).to_s) if ModelFactory.gbm_4_3?(@xml)
          Float(@xml.xpath(CONST_XPATH_4_2).first.content)
        end
      end
    end
  end
end
