require 'scoruby/models/naive_bayes/data'
require 'forwardable'

module Scoruby
  module Models
    module NaiveBayes
      class Model
        extend Forwardable
        attr_reader :model_data
        def_delegators :@model_data, :labels, :data, :threshold

        def initialize(xml)
          @model_data = ModelData.new(xml)

        end

        def lvalues(features)
          labels.each do |label, _|
            features.each do |feature_name, feature_value|

              if data[feature_name][feature_value]
                value_count = data[feature_name][feature_value][label].to_f
                overall_count = data[feature_name].sum { |_, value| value[label].to_f }

                labels[label][feature_name] = value_count / overall_count
              elsif data[feature_name][label]
                labels[label][feature_name] = calc_numerical(data[feature_name][label], feature_value)
              end
            end
          end

          lvalues = {}
          labels.each do |label, label_data|
            label_data.each do |key, value|
              label_data[key] = threshold if value.round(5).zero?
            end
            lvalues[label] = label_data.values.reduce(:*)
          end
          lvalues
        end

        def score(features, label)
          lvalues = lvalues(features)
          lvalues[label] / lvalues.values.reduce(:+)
        end

        private

        def calc_numerical(label_data, feature_value)
          variance = label_data[:variance].to_f
          mean = label_data[:mean].to_f
          feature_value = feature_value.to_f

          Math.exp(-(feature_value - mean)**2 / (2 * variance)) / Math.sqrt(2 * Math::PI * variance)
        end
      end
    end
  end
end
