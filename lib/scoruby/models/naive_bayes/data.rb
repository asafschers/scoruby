module Scoruby
  module Models
    module NaiveBayes
      class ModelData
        attr_reader :threshold, :data, :labels

        def initialize(xml)
          @threshold = xml.xpath('//NaiveBayesModel').attr('threshold').value.to_f
          @data = {}
          xml.xpath('//BayesInput').each do |feature|
            @data[feature.attr('fieldName').to_sym] = fetch_feature(feature)
          end

          @labels = {}
          xml.xpath('//BayesOutput//TargetValueCount').each do |l| l.attr('value')
          @labels[l.attr('value')] = { 'count': l.attr('count').to_f }
          end
        end

        private

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
end