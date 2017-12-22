# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::RandomForest::Data do
  let(:rf_file) { 'spec/fixtures/titanic_rf.pmml' }
  let(:xml) { Scoruby.xml_from_file_path(rf_file) }
  let(:data) { described_class.new(xml) }
  let(:trees_count) { data.decision_trees.count }
  let(:continuous_features) { %w[Age Fare Parch PassengerId Pclass SibSp] }

  it 'loads correct number of trees' do
    expect(trees_count).to eq 15
  end

  it 'loads continuous features' do
    expect(data.continuous_features).to match_array continuous_features
  end
  #
  # it 'loads categorical features' do
  #   expect(trees_count).to eq 1
  # end
end
