require 'spec_helper'

describe RandomForest do

  RF_FILE = 'rf_file'
  NON_RF_FILE = 'non_rf_file'

  let(:rf_file) { 'spec/fixtures/rf_file.pmml' }

  it 'raises when type not random forest' do
    rf_model = RandomForester.get_model(rf_file)
    rf_model.predict
  end

end
