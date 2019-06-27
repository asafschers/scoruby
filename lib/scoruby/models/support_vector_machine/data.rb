# frozen_string_literal: true

module Scoruby
  module Models
    module SupportVectorMachine
      class Data
        COEFFICIENTS_XPATH = 'PMML/SupportVectorMachineModel/SupportVectorMachine/Coefficients/Coefficient'

        def initialize(xml)
          @xml = xml
        end

        def coefficients
          @xml.xpath(COEFFICIENTS_XPATH).map { |c| c.attr('value').to_i }
        end
      end
    end
  end
end
