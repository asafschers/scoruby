require 'random_forester/version'
require 'nokogiri'
require 'random_forest'
require 'logger'
require 'pry'

RANDOM_FOREST_MODEL = 'randomForest_Model'
MODEL_NOT_SUPPORTED_ERROR = 'model not supported'

module RandomForester

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
    case get_model_type(xml)
      when RANDOM_FOREST_MODEL
        RandomForest.new(xml)
      else
        raise MODEL_NOT_SUPPORTED_ERROR
    end
  end

  def self.xml_from_file_path(pmml_file_name)
    pmml_string = File.open(pmml_file_name, 'rb').read
    xml_from_string(pmml_string)
  end

  def self.xml_from_string(pmml_string)
    xml = Nokogiri::XML(pmml_string) { |config| config.noblanks }
    xml.remove_namespaces!
  end

  def self.get_model_type(xml)
    xml.xpath("PMML/MiningModel/@modelName").to_s
  end
end
