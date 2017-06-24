require 'spec_helper'

describe RandomForest do

  before(:all) do
    rf_file = 'spec/fixtures/titanic_rf.pmml'
    xml = Scoruby.xml_from_file_path(rf_file)
    @random_forest = RandomForest.new(xml)

  end

  def approve_features
    {
        Sex: 'male',
        Parch: 0,
        Age: 30,
        Fare: 9.6875,
        Pclass: 2,
        SibSp: 0,
        Embarked: 'Q'
        
    }
  end

  def decline_features
    {
        Sex: 'female',
        Parch: 0,
        Age: 38,
        Fare: 71.2833,
        Pclass: 2,
        SibSp: 1,
        Embarked: 'C'
    }
  end

  it 'predicts 0' do
    expect(@random_forest.predict(approve_features)).to eq '0'
    decisions_count = @random_forest.decisions_count(approve_features)
    expect(decisions_count['0']).to eq 441
    expect(decisions_count['1']).to eq 59
  end

  it 'predicts 1' do
    expect(@random_forest.predict(decline_features)).to eq '1'
    decisions_count = @random_forest.decisions_count(decline_features)
    expect(decisions_count['0']).to eq 41
    expect(decisions_count['1']).to eq 459
  end
end
