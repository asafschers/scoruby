require 'spec_helper'

describe RandomForest do

  SHOULD_APPROVE = 'should_approve'
  SHOULD_DECLINE = 'should_decline'

  before(:all) do
    rf_file = 'spec/fixtures/rf_file.pmml'
    xml = RandomForester.get_xml(rf_file)
    @random_forest = RandomForest.new(xml)
    @features = Hash.new
  end

  it 'predicts approve' do
    (1..67).each { |i| @features[:"f#{i}"] = 0}
    expect(@random_forest.predict(@features)).to eq SHOULD_APPROVE
    decisions_count = @random_forest.decisions_count(@features)
    expect(decisions_count[SHOULD_APPROVE]).to eq 160
    expect(decisions_count[SHOULD_DECLINE]).to eq 140
  end

  it 'predicts decline' do
    (1..67).each { |i| @features[:"f#{i}"] = 3000}
    expect(@random_forest.predict(@features)).to eq SHOULD_DECLINE
    decisions_count = @random_forest.decisions_count(@features)
    expect(decisions_count[SHOULD_APPROVE]).to eq 142
    expect(decisions_count[SHOULD_DECLINE]).to eq 158
  end

end
