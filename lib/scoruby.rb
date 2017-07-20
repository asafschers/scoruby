require 'scoruby/version'
require 'scoruby/models_factory'
require 'nokogiri'
require 'logger'

module Scoruby
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
    ModelsFactory.factory_for(xml)
  end

  def self.xml_from_file_path(pmml_file_name)
    pmml_string = File.open(pmml_file_name, 'rb').read
    xml_from_string(pmml_string)
  end

  def self.xml_from_string(pmml_string)
    xml = Nokogiri::XML(pmml_string) { |config| config.noblanks }
    xml.remove_namespaces!
  end
end
