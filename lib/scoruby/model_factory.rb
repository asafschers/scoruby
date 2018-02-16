# frozen_string_literal: true

require 'scoruby/models/decision_tree'
require 'scoruby/models/gradient_boosted_model/model'
require 'scoruby/models/random_forest/model'
require 'scoruby/models/naive_bayes/model'

module Scoruby
  class ModelFactory
    RANDOM_FOREST_MODEL       = 'randomForest_Model'
    GBM_INDICATION_4_2        = '//OutputField[@name="scaledGbmValue"]'
    GBM_INDICATION_4_3        = '//OutputField[@name="gbmValue"]'
    MODEL_NOT_SUPPORTED_ERROR = 'model not supported'

    def self.factory_for(xml)
      return Models::RandomForest::Model.new(xml) if random_forest?(xml)
      return Models::GradientBoostedModel::Model.new(xml) if gbm?(xml)
      return Models::DecisionTree.new(xml.child) if decision_tree?(xml)
      return Models::NaiveBayes::Model.new(xml) if naive_bayes?(xml)

      raise MODEL_NOT_SUPPORTED_ERROR
    end

    def self.naive_bayes?(xml)
      !xml.xpath('PMML/NaiveBayesModel').empty?
    end

    def self.decision_tree?(xml)
      !xml.xpath('PMML/TreeModel').empty?
    end

    def self.random_forest?(xml)
      xml.xpath('PMML/MiningModel/@modelName').to_s == RANDOM_FOREST_MODEL ||
        xml.xpath('//Extension').to_s.include?('RandomForestClassifier')
    end

    def self.gbm?(xml)
      gbm_4_2?(xml) || gbm_4_3?(xml)
    end

    def self.gbm_4_2?(xml)
      !xml.xpath(GBM_INDICATION_4_2).empty?
    end

    def self.gbm_4_3?(xml)
      !xml.xpath(GBM_INDICATION_4_3).empty?
    end
  end
end
