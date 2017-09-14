module Scoruby
  module Models
    class NaiveBayes
      attr_reader :data

      def initialize(xml)
        @data = {}
        xml.xpath('//BayesInput').each do |feature|
          @data[feature.attr('fieldName').to_sym] = fetch_feature(feature)
        end

        @labels = {}
        xml.xpath('//BayesOutput//TargetValueCount').each do |l| l.attr('value')
          @labels[l.attr('value')] = { 'count': l.attr('count') }
        end
      end

      def score(features)
        @labels.each do |label, _|
          features.each do |feature_name, feature_value|

            if @data[feature_name][feature_value]
              value_count = @data[feature_name][feature_value][label].to_f
              overall_count = @data[feature_name].sum { |_, value| value[label].to_f }

              @labels[label][feature_name] = value_count / overall_count
            elsif @data[feature_name][label]
              @labels[label][feature_name] = calc_numerical(@data[feature_name][label], feature_value)
            end

            # TODO: consider threshold on 0
            # TODO: calc score from label probabilities 
          end
        end
      end

      private

      def calc_numerical(label_data, feature_value)
        variance = label_data[:variance].to_f
        mean = label_data[:mean].to_f
        feature_value = feature_value.to_f

        Math.exp(-(feature_value - mean)**2 / (2 * variance)) / Math.sqrt(2 * Math::PI * variance)
      end

      def fetch_feature(feature)
        return fetch_numerical_feature(feature) if feature.child.name == 'TargetValueStats'
        fetch_category_feature(feature)
      end

      def fetch_numerical_feature(feature)
        features_data = {}
        feature.child.children.each do |child|
          features_data[child.attr('value').strip] = {
            mean: child.child.attr('mean'),
            variance: child.child.attr('variance')
          }
        end
        features_data
      end

      def fetch_category_feature(feature)
        feature_data = {}
        feature.children.each do |category|
          feature_data[category.attr('value')] = fetch_category(category)
        end
        feature_data
      end

      def fetch_category(category)
        category_data = {}
        category.child.children.each do |label|
          category_data[label.attr('value')] = label.attr('count')
        end
        category_data
      end
    end
  end
end
