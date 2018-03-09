# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::GradientBoostedModel::Model do
  let(:xml) { Scoruby.xml_from_file_path(gbm_file) }
  let(:gbm) { described_class.new(xml) }

  context 'pmml 4.3' do
    let(:gbm_file) { 'spec/fixtures/titanic_gbm.pmml' }
    let(:features1) do
      { Sex: 'male', Parch: 0, Age: 30, Fare: 9.6875,
        Pclass: 2, SibSp: 0, Embarked: 'Q' }
    end
    let(:features2) do
      { Sex: 'female', Parch: 0, Age: 38, Fare: 71.2833,
        Pclass: 2, SibSp: 1, Embarked: 'C' }
    end

    it 'predicts approve' do
      expect(gbm.score(features1)).to eq 0.7990679530500985
    end

    it 'predicts decline' do
      expect(gbm.score(features2)).to eq 0.8009413525080109
    end
  end

  context 'pmml 4.2' do
    let(:gbm_file) { 'spec/fixtures/titanic_gbm_4_2.pmml' }
    let(:features1) do
      { Sex: 'male', Parch: 0, Age: 30, Fare: 9.6875,
        Pclass: 2, SibSp: 0, Embarked: 'Q' }
    end
    let(:features2) do
      { Sex: 'female', Parch: 0, Age: 38, Fare: 71.2833,
        Pclass: 2, SibSp: 1, Embarked: 'C' }
    end

    it 'predicts approve' do
      expect(gbm.score(features1)).to eq 0.3652639329522468
    end

    it 'predicts decline' do
      expect(gbm.score(features2)).to eq 0.4178155014037758
    end
  end
end
