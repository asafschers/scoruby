require 'scoruby/models/naive_bayes/model_data'
require 'forwardable'

module Scoruby
  module Models
    module NaiveBayes
      class Model
        extend Forwardable
        def_delegators :@model_data, :threshold, :labels, :numerical_features, :category_features

        def initialize(xml)
          @model_data = ModelData.new(xml)
        end

        def lvalues(features)
          calc_label_feature_values(features)
          calc_label_values
        end

        def score(features, label)
          lvalues(features)[label] / lvalues(features).values.reduce(:+)
        end

        private

        def calc_label_values
          label_values = {}
          labels.each do |label, label_data|
            label_data.each do |key, value|
              label_data[key] = threshold if value.round(5).zero?
            end
            label_values[label] = label_data.values.reduce(:*)
          end
          label_values
        end

        def calc_label_feature_values(features)
          labels.each do |label, _|
            features.each do |feature_name, feature_value|
              label_value = calc_category(feature_name, feature_value, label)
              label_value ||= calc_numerical(feature_name, feature_value, label)
              labels[label][feature_name] = label_value if label_value
            end
          end
        end

        def calc_category(feature_name, feature_value, label)
          return unless category_features[feature_name] && category_features[feature_name][feature_value]
          value_count = category_features[feature_name][feature_value][label].to_f
          overall_count = category_features[feature_name].map { |_, value| value[label].to_f }.reduce(0, :+)
          value_count / overall_count
        end

        def calc_numerical(feature_name, feature_value, label)
          return unless numerical_features[feature_name] && numerical_features[feature_name][label]
          variance = numerical_features[feature_name][label][:variance].to_f
          mean = numerical_features[feature_name][label][:mean].to_f
          feature_value = feature_value.to_f
          Math.exp(-(feature_value - mean)**2 / (2 * variance)) / Math.sqrt(2 * Math::PI * variance)
        end
      end
    end
  end
end
