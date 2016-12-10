require 'json'

pmml_file = '' #pmml file name
json = '' #get features json from oscd

get_missing_categories(json,pmml_file)

def get_category_feature_names(pmml_file)
  xml = RandomForester.get_xml pmml_file;
  features = {}
  xml.xpath("PMML/DataDictionary/*").each { |df| features[df.xpath('@name').to_s] = df.xpath('@dataType').to_s }
  features.select { |_, v| v == 'string' }.keys
end

def get_categories(json, pmml_file)
  curr_features = JSON.parse(json)
  category_features = get_category_feature_names(pmml_file)
  curr_features.select { |k, _| category_features.include?(k)}
end

def get_missing_categories(json, pmml_file)
  categories = get_categories(json, pmml_file)
  categories.each { |k, v|
    next if !!v == v
    category_on_pmml = File.readlines(pmml_file).any?{ |l| l[v.to_s] }
    puts "category: #{k}, value: #{v}" unless category_on_pmml
  }; nil
end





