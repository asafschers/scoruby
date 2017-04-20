require 'spec_helper'

describe Gbm do

  let(:gbm_file) { 'spec/fixtures/gbm_sample.pmml'}
  let(:xml) { RandomForester.xml_from_file_path(gbm_file) }
  let(:gbm) { Gbm.new(xml) }

  it 'loads correct number of trees' do
    expect(gbm.tree_count).to eq 30
  end

  def approve_features
    features = {}
    (1..110).each { |i| features[:"f#{i}"] = 0 if features[:"f#{i}"].nil? }
    features
  end

  def decline_features
    features = {}
    (1..110).each { |i| features[:"f#{i}"] = 3000 if features[:"f#{i}"].nil? }
    features
  end
  
  it 'predicts approve' do
    expect(gbm.score(approve_features)).to eq 0.6736069972600348
  end

  it 'predicts decline' do
    expect(gbm.score(decline_features)).to eq 0.48682675281447374
  end

end
