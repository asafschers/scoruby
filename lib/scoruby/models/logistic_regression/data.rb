# frozen_string_literal: true

module Scoruby
  module Models
    module LogisticRegression
      class Data
        COEFFICIENTS_VALUES_PATH = '//PMML/GeneralRegressionModel/ParamMatrix/PCell/@beta'
        COEFFICIENTS_LABELS_PATH = '//PMML/GeneralRegressionModel/ParameterList/Parameter/@label'

        def initialize(xml)
          @xml = xml
        end

        def coefficient_values
          @xml.xpath(COEFFICIENTS_VALUES_PATH).map{|attribute| attribute.value.to_f}
        end

        def coefficient_labels
          @xml.xpath(COEFFICIENTS_LABELS_PATH).map(&:value)
        end

        def coefficients
          @coefficients ||= Hash[coefficient_labels.zip(coefficient_values)]
        end
      end
    end
  end
end
