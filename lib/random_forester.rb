require 'random_forester/version'
require 'nokogiri'
require 'random_forest'

RANDOM_FOREST_MODEL = 'randomForest_Model'
MODEL_NOT_SUPPORTED_ERROR = 'model not supported'

module RandomForester
  def self.get_model(pmml_file_name)
    xml = get_xml(pmml_file_name)
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

  def self.get_xml(pmml_file_name)
    pmml_string = File.open(pmml_file_name, 'rb').read
    xml = Nokogiri::XML(pmml_string)
    xml.remove_namespaces!
  end

  def self.get_model_type(xml)
    xml.xpath("PMML/MiningModel/@modelName").to_s
  end
end
