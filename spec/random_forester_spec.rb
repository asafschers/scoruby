require 'spec_helper'

describe Scoruby do

  let(:rf_file) { 'spec/fixtures/titanic_rf.pmml' }
  let(:non_rf_file) { 'spec/fixtures/non_rf_file.pmml' }
  let(:decision_tree_file) { 'spec/fixtures/decision_tree.pmml' }
  let(:gbm_file) { 'spec/fixtures/gbm_file.pmml' }

  it 'raises when type not known' do
    expect {
      Scoruby.get_model(non_rf_file)
    }.to raise_error(ModelsFactory::MODEL_NOT_SUPPORTED_ERROR)
  end

  it 'initializes random forest' do
    expect(Scoruby.get_model(rf_file)).to be_a(RandomForest)
  end

  it 'initializes gbm ' do
    expect(Scoruby.get_model(gbm_file)).to be_a(Gbm)
  end
end
