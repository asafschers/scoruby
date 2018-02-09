# frozen_string_literal: true

require 'scoruby/features'
require 'forwardable'
require 'scoruby/models/gradient_boosted_model/data'

module Scoruby
  module Models
    module GradientBoostedModel
      class Model
        extend Forwardable
        def_delegators :@data, :decision_trees, :const, :continuous_features,
                       :categorical_features

        def initialize(xml)
          @data = Data.new(xml)
        end

        def score(features)
          formatted_features = Features.new(features).formatted
          scores = traverse_trees(formatted_features)
          sum = scores.reduce(:+) + const
          Math.exp(sum) / (1 + Math.exp(sum))
        end

        def traverse_trees(formatted_features)
          decision_trees.map do |dt|
            dt.decide(formatted_features).score.to_s.to_f
          end
        end
      end
    end
  end
end
