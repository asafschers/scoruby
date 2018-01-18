# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::Gbm do
  let(:xml) { Scoruby.xml_from_file_path(gbm_file) }
  let(:gbm) { described_class.new(xml) }
  let(:approve_features) { { Sex: 'male', Parch: 0, Age: 30, Fare: 9.6875, Pclass: 2, SibSp: 0, Embarked: 'Q' } }
  let(:decline_features) { { Sex: 'female', Parch: 0, Age: 38, Fare: 71.2833, Pclass: 2, SibSp: 1, Embarked: 'C' } }

  context 'pmml 4.3' do
    let(:gbm_file) { 'spec/fixtures/titanic_gbm.pmml' }

    it 'loads correct number of trees' do
      expect(gbm.tree_count).to eq 100
    end

    it 'predicts approve' do
      expect(gbm.score(approve_features)).to eq 0.3652639329522468
    end

    it 'predicts decline' do
      expect(gbm.score(decline_features)).to eq 0.4178155014037758
    end
  end

  context 'pmml 4.2' do
    let(:gbm_file) { 'spec/fixtures/titanic_gbm_4_2.pmml' }

    it 'loads correct number of trees' do
      expect(gbm.tree_count).to eq 100
    end

    it 'predicts approve' do
      expect(gbm.score(approve_features)).to eq 0.3652639329522468
    end

    it 'predicts decline' do
      expect(gbm.score(decline_features)).to eq 0.4178155014037758
    end
  end
end
