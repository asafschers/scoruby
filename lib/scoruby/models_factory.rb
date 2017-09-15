require 'scoruby/models/decision_tree'
require 'scoruby/models/gbm'
require 'scoruby/models/random_forest'
require 'scoruby/models/naive_bayes/model'

module Scoruby
  class ModelsFactory
    RANDOM_FOREST_MODEL       = 'randomForest_Model'
    GBM_INDICATION            = '//OutputField[@name="scaledGbmValue"]'
    MODEL_NOT_SUPPORTED_ERROR = 'model not supported'

    def self.factory_for(xml)
      return Models::RandomForest.new(xml) if random_forest?(xml)
      return Models::Gbm.new(xml) if gbm?(xml)
      return Models::DecisionTree.new(xml.child) if decision_tree?(xml)
      return Models::NaiveBayes::Model.new(xml.child) if naive_bayes?(xml)

      raise MODEL_NOT_SUPPORTED_ERROR
    end

    def self.decision_tree?(xml)
      !xml.xpath('PMML/TreeModel').empty?
    end

    def self.random_forest?(xml)
      xml.xpath('PMML/MiningModel/@modelName').to_s == RANDOM_FOREST_MODEL
    end

    def self.gbm?(xml)
      !xml.xpath(GBM_INDICATION).empty?
    end
    def self.naive_bayes?(xml)
      !xml.xpath('PMML/NaiveBayesModel').empty?
    end
  end
end
