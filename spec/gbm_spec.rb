require 'spec_helper'

describe Gbm do

  let(:gbm_file) { 'spec/fixtures/titanic_gbm.pmml'}
  let(:xml) { Scoruby.xml_from_file_path(gbm_file) }
  let(:gbm) { Gbm.new(xml) }

  it 'loads correct number of trees' do
    expect(gbm.tree_count).to eq 100
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
  
  it 'predicts approve' do
    expect(gbm.score(approve_features)).to eq 0.3652639329522468
  end

  it 'predicts decline' do
    expect(gbm.score(decline_features)).to eq 0.4178155014037758
  end

end
