require 'spec_helper'

describe Gbm do

  let(:gbm_file) { 'spec/fixtures/gbm_sample.pmml'}
  let(:xml) { RandomForester.xml_from_file_path(gbm_file) }
  let(:gbm) { Gbm.new(xml) }

  xit 'loads correct number of trees' do
    expect(gbm.tree_count).to eq 30
  end

end
