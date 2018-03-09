# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::GradientBoostedModel::Data do
  let(:xml) { Scoruby.xml_from_file_path(gbm_file) }
  let(:gbm_file) { 'spec/fixtures/titanic_gbm.pmml' }
  let(:data) { described_class.new(xml) }
  let(:categorical_features) { { Sex: %w[female male] } }

  it 'loads correct number of trees' do
    expect(data.decision_trees.count).to eq 15
  end

  it 'loads continuous features' do
    expect(data.continuous_features).to match_array %i[Survived Pclass Age Fare]
  end

  it 'loads categorical features' do
    expect(data.categorical_features).to match categorical_features
  end

  context 'const value' do
    context 'pmml 4.3' do
      let(:const) { 1.3838383838383839 }
      it 'loads const' do
        expect(data.const).to eq const
      end
    end

    context 'pmml 4.2' do
      let(:const) { -0.4732877044469254 }
      let(:gbm_file) { 'spec/fixtures/titanic_gbm_4_2.pmml' }
      it 'loads const' do
        expect(data.const).to eq const
      end
    end
  end
end
