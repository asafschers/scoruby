require 'spec_helper'

describe RandomForester do

  let(:rf_file) { 'spec/fixtures/rf_file.pmml' }
  let(:non_rf_file) { 'spec/fixtures/non_rf_file.pmml' }
  let(:decision_tree_file) { 'spec/fixtures/decision_tree.pmml' }
  let(:gbm_file) { 'spec/fixtures/gbm_file.pmml' }

  it 'raises when type not known' do
    expect {
      RandomForester.get_model(non_rf_file)
    }.to raise_error(RandomForester::MODEL_NOT_SUPPORTED_ERROR)
  end

  it 'initializes random forest' do
    expect(RandomForester.get_model(rf_file)).to be_a(RandomForest)
  end

  it 'initializes gbm ' do
    expect(RandomForester.get_model(gbm_file)).to be_a(Gbm)
  end
end
