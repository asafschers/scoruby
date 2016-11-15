require 'spec_helper'

describe RandomForester do

  RF_FILE = 'rf_file'
  NON_RF_FILE = 'non_rf_file'

  let(:rf_file) { 'spec/fixtures/rf_file.pmml' }
  let(:non_rf_file) { 'spec/fixtures/non_rf_file.pmml' }

  it 'raises when type not random forest' do
    expect {
      RandomForester.get_model(non_rf_file)
    }.to raise_error(MODEL_NOT_SUPPORTED_ERROR)
  end

  it 'inits random forest when type random forest' do
    model = RandomForester.get_model(rf_file)
    expect(model).to be_an_instance_of(RandomForest)
  end
end
