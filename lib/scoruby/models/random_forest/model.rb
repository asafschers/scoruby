# frozen_string_literal: true

require 'scoruby/models/random_forest/data'
require 'forwardable'

module Scoruby
  module Models
    module RandomForest
      class Model
        extend Forwardable
        def_delegators :@data, :decision_trees, :categorical_features,
                       :continuous_features, :regression?

        def initialize(xml)
          @data = Data.new(xml)
        end

        def score(features)
          decisions_count = decisions_count(features)

          if regression?
            {
              response: sum(decisions_count.map { |k, v| k.to_f * v }) / sum(decisions_count.values)
            }
          else
            decision = decisions_count.max_by { |_, v| v }
            {
              label: decision[0],
              score: decision[1] / sum(decisions_count.values).to_f
            }
          end
        end

        def decisions_count(features)
          formatted_features = Features.new(features).formatted
          decisions = traverse_trees(formatted_features)
          aggregate_decisions(decisions)
        end

        private

        def traverse_trees(formatted_features)
          decision_trees.map do |decision_tree|
            decision_tree.decide(formatted_features).score
          end
        end

        def aggregate_decisions(decisions)
          decisions.each_with_object(Hash.new(0)) do |score, counts|
            counts[score] += 1
          end
        end

        def sum(values)
          values.reduce(0, :+)
        end
      end
    end
  end
end
