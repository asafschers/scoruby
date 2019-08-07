# frozen_string_literal: true

require 'scoruby/models/logistic_regression/data'
require 'forwardable'

module Scoruby
  module Models
    module LogisticRegression
      class Model
        extend Forwardable
        def_delegators :@data, :coefficients, :coefficient_values

        def initialize(xml)
          @data = Data.new(xml)
        end

        def intercept
          coefficient_values.first
        end

        def score(features)
          logodds = intercept
          features.each do |key, value|
            logodds += coefficients[key] * value
          end

          1.0 / (1.0 + Math.exp(-logodds))
        end
      end
    end
  end
end
