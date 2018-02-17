# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::RandomForest::Data do
  let(:rf_file) { 'spec/fixtures/titanic_rf.pmml' }
  let(:xml) { Scoruby.xml_from_file_path(rf_file) }
  let(:data) { described_class.new(xml) }
  let(:trees_count) { data.decision_trees.count }
  let(:continuous_features) { %i[Age Fare Parch Pclass SibSp] }
  let(:categorical_features) do
    { Sex: %w[female male], Embarked: ['C', '', 'Q', 'S'] }
  end

  it 'loads correct number of trees' do
    expect(trees_count).to eq 15
  end

  it 'loads continuous features' do
    expect(data.continuous_features).to match_array continuous_features
  end

  it 'loads categorical features' do
    expect(data.categorical_features).to match categorical_features
  end
end
