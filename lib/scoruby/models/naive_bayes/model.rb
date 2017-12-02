# frozen_string_literal: true

require 'scoruby/models/naive_bayes/model_data'
require 'forwardable'

module Scoruby
  module Models
    module NaiveBayes
      class Model
        extend Forwardable
        def_delegators :@model_data, :threshold, :labels, :numerical_features,
                       :category_features

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
          labels.each_key do |label|
            features.each do |feature_name, feature_value|
              label_value = category(feature_name, feature_value, label)
              label_value ||= numerical(feature_name, feature_value, label)
              labels[label][feature_name] = label_value if label_value
            end
          end
        end

        def category(feature_name, feature_value, label)
          model_feature = category_features[feature_name]
          return unless model_feature && model_feature[feature_value]
          value_count = model_feature[feature_value][label].to_f
          overall_count = model_feature.map { |_, value| value[label].to_f }
                                       .reduce(0, :+)
          value_count / overall_count
        end

        def numerical(feature_name, feature_value, label)
          model_feature = numerical_features[feature_name]
          return unless model_feature && model_feature[label]
          calc_numerical(feature_value.to_f,
                         model_feature[label][:mean].to_f,
                         model_feature[label][:variance].to_f)
        end

        def calc_numerical(feature_value, mean, variance)
          Math.exp(-(feature_value - mean)**2 / (2 * variance)) /
            Math.sqrt(2 * Math::PI * variance)
        end
      end
    end
  end
end
