require 'spec_helper'

describe RandomForest do

  SHOULD_APPROVE ||= 'should_approve'
  SHOULD_DECLINE ||= 'should_decline'

  before(:all) do
    rf_file = 'spec/fixtures/rf_file.pmml'
    xml = RandomForester.xml_from_file_path(rf_file)
    @random_forest = RandomForest.new(xml)
    @features = Hash.new
  end

  def categorial_features
    {
      f5: 'Linux',
      f6: 'Chrome',
      f13: 'F1L',
      f15: 'f',
      f19: 'cellular',
      f20: 'Corporate',
      f26: 'ValidDomain',
      f31: 'female',
      f35: 'f',
      f36: 'F1L',
      f38: 'NO_EA_LOCATION',
      f49: 'field mismatch',
      f53: 'field_match',
      f54: 'field mismatch',
      f55: 'FL',
      f63: 'match',
      f65: 'all_uppercase',
      f66: 'all_lowercase',
      f67: 'Missing'
    }
  end

  def approve_features
    features = categorial_features
    (1..67).each { |i| features[:"f#{i}"] = 0 if features[:"f#{i}"].nil? }
    features
  end

  def decline_features
    features = categorial_features
    (1..67).each { |i| features[:"f#{i}"] = 3000 if features[:"f#{i}"].nil? }
    features
  end

  it 'predicts approve' do
    expect(@random_forest.predict(approve_features)).to eq SHOULD_APPROVE
    decisions_count = @random_forest.decisions_count(approve_features)
    expect(decisions_count[SHOULD_APPROVE]).to eq 12
    expect(decisions_count[SHOULD_DECLINE]).to eq 3
  end

  it 'predicts decline' do
    expect(@random_forest.predict(decline_features)).to eq SHOULD_DECLINE
    decisions_count = @random_forest.decisions_count(decline_features)
    expect(decisions_count[SHOULD_APPROVE]).to eq 6
    expect(decisions_count[SHOULD_DECLINE]).to eq 9
  end

end
