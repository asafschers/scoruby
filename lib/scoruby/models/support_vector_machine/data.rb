# frozen_string_literal: true

module Scoruby
  module Models
    module SupportVectorMachine
      class Data
        SUPPORT_VECTORS_XPATH = 'PMML/SupportVectorMachineModel/SupportVectorMachine/SupportVectors/SupportVector'
        COEFFICIENTS_XPATH = 'PMML/SupportVectorMachineModel/SupportVectorMachine/Coefficients/Coefficient'
        ABSOLUTE_VALUE_XPATH = 'PMML/SupportVectorMachineModel/SupportVectorMachine/Coefficients'

        def initialize(xml)
          @xml = xml
        end

        def absolute_value
          @xml.xpath(ABSOLUTE_VALUE_XPATH).attribute('absoluteValue').value.to_i
        end

        def coefficients
          @xml.xpath(COEFFICIENTS_XPATH).map { |c| c.attr('value').to_i }
        end

        def support_vectors_ids
          @xml.xpath(SUPPORT_VECTORS_XPATH).map { |c| c.attr('vectorId') }
        end
      end
    end
  end
end
