require 'random_forester/version'
require 'nokogiri'
require 'random_forest'
require 'gbm'
require 'logger'
require 'pry'

module RandomForester
  RANDOM_FOREST_MODEL = 'randomForest_Model'
  GBM_INDICATION = '//OutputField[@name="scaledGbmValue"]'
  MODEL_NOT_SUPPORTED_ERROR = 'model not supported'
  RF_FOREST_XPATH = 'PMML/MiningModel/Segmentation/Segment'

  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.name
      end
    end
  end

  def self.get_model(pmml_file_name)
    xml = xml_from_file_path(pmml_file_name)
    new_model(xml)
  end

  def self.new_model(xml)
    return RandomForest.new(xml, DecisionTree, RF_FOREST_XPATH) if random_forest?(xml)
    return Gbm.new(xml) if gbm?(xml)
    raise MODEL_NOT_SUPPORTED_ERROR
  end

  def self.xml_from_file_path(pmml_file_name)
    pmml_string = File.open(pmml_file_name, 'rb').read
    xml_from_string(pmml_string)
  end

  def self.xml_from_string(pmml_string)
    xml = Nokogiri::XML(pmml_string) { |config| config.noblanks }
    xml.remove_namespaces!
  end

  def self.random_forest?(xml)
    xml.xpath('PMML/MiningModel/@modelName').to_s == RANDOM_FOREST_MODEL
  end

  def self.gbm?(xml)
    !xml.xpath(GBM_INDICATION).empty?
  end
end
