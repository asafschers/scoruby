require 'spec_helper'

describe RandomForest do

  let(:rf_file) { 'spec/fixtures/rf_file.pmml' }
  let(:xml) { RandomForester.get_xml(rf_file) }
  let(:random_forest) { RandomForest.new(xml) }

  it 'predicts approve' do
    expect(random_forest.predict({})).to eq DecisionTree::SHOULD_APPROVE
  end

  it 'predicts approve' do
    expect(random_forest.predict({})).to eq DecisionTree::SHOULD_DECLINE
  end

end
