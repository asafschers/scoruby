require 'spec_helper'

describe RandomForester do

  let(:rf_file) { 'spec/fixtures/rf_file.pmml' }
  let(:non_rf_file) { 'spec/fixtures/non_rf_file.pmml' }

  it 'raises when type not random forest' do
    expect {
      RandomForester.get_model(non_rf_file)
    }.to raise_error(MODEL_NOT_SUPPORTED_ERROR)
  end

end
