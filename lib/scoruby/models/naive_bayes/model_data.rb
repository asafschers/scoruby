module Scoruby
  module Models
    module NaiveBayes
      class ModelData
        attr_reader :threshold, :labels, :numerical_features, :category_features

        def initialize(xml)
          @xml = xml
          fetch_threshold
          fetch_features_data
          fetch_label_counts
        end

        private

        def fetch_threshold
          @threshold = @xml.xpath('//NaiveBayesModel').attr('threshold').value.to_f
        end

        def fetch_features_data
          @category_features = {}
          @numerical_features = {}
          @xml.xpath('//BayesInput').each do |feature|
            @category_features[feature.attr('fieldName').to_sym] = fetch_category_feature(feature)
            @numerical_features[feature.attr('fieldName').to_sym] = fetch_numerical_feature(feature)
          end
        end

        def fetch_label_counts
          @labels = {}
          @xml.xpath('//BayesOutput//TargetValueCount').each do |l|
            l.attr('value')
            @labels[l.attr('value')] = { 'count': l.attr('count').to_f }
          end
        end
        
        def fetch_numerical_feature(feature)
          return unless feature.child.name == 'TargetValueStats'
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
          return unless feature.children.any? { |f| f.name == 'PairCounts' }
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
end