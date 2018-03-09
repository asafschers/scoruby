# frozen_string_literal: true

require 'scoruby/models/decision_tree'
require 'scoruby/models/gradient_boosted_model/model'
require 'scoruby/models/random_forest/model'
require 'scoruby/models/naive_bayes/model'

module Scoruby
  class ModelFactory
    RANDOM_FOREST_MODEL       = 'randomForest_Model'
    GBM_INDICATION            = '//Segmentation[@multipleModelMethod="sum"]'
    RF_INDICATION             = '//Segmentation[@multipleModelMethod="average"]'
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
        xml.at(RF_INDICATION)
    end

    def self.gbm?(xml)
      xml.at(GBM_INDICATION)
    end
  end
end
