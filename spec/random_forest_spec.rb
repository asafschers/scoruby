require 'spec_helper'

describe RandomForest do

  before(:all) do
    rf_file = 'spec/fixtures/rf_file.pmml'
    xml = RandomForester.get_xml(rf_file)
    @random_forest = RandomForest.new(xml)
    @features = Hash.new
  end

  it 'predicts approve' do
    (1..65).each { |i| @features[:"f#{i}"] = 3}
    puts @random_forest.predict(@features)
  end

  it 'predicts decline' do
    (1..65).each { |i| @features[:"f#{i}"] = 100}
    puts @random_forest.predict(@features)
  end

end
