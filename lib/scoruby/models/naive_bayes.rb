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
          features.each do |feature_name, value|

            @labels[label][feature_name] = @data[feature_name][value][label] if @data[feature_name][value]

            # TODO: handle nil
            # TODO: handle numerical
            # TODO: calc sum and ratio
            # TODO: consider threshold on 0
          end
        end

        # puts @labels
      end

      private

      def fetch_feature(feature)
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
