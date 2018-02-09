# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::GradientBoostedModel::Data do
  let(:xml) { Scoruby.xml_from_file_path(gbm_file) }
  let(:gbm_file) { 'spec/fixtures/titanic_gbm.pmml' }
  let(:data) { described_class.new(xml) }
  let(:continuous_features) { %i[Age Fare Parch Pclass SibSp] }
  let(:categorical_features) {
    { Sex: %w[female male] }
  }

  it 'loads correct number of trees' do
    expect(data.decision_trees.count).to eq 100
  end

  it 'loads continuous features' do
    expect(data.continuous_features).to be_empty
  end

  it 'loads categorical features' do
    expect(data.categorical_features).to match categorical_features
  end

  context 'const value' do
    let(:const) { -0.4732877044469254 }
    context 'pmml 4.3' do
      it 'loads correct number of trees' do
        expect(data.const).to eq const
      end
    end

    context 'pmml 4.2' do
      let(:gbm_file) { 'spec/fixtures/titanic_gbm_4_2.pmml' }
      it 'loads correct number of trees' do
        expect(data.const).to eq const
      end
    end
  end
end
