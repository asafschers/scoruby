require 'models/random_forest'
require 'models/gbm'

class ModelsFactory
  RANDOM_FOREST_MODEL = 'randomForest_Model'
  GBM_INDICATION = '//OutputField[@name="scaledGbmValue"]'
  MODEL_NOT_SUPPORTED_ERROR = 'model not supported'

  def self.factory_for(xml)
    return RandomForest.new(xml) if random_forest?(xml)
    return Gbm.new(xml) if gbm?(xml)
    return DecisionTree.new(xml.child) if decision_tree?(xml)

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
end
