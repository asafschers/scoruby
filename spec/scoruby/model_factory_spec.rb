# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::ModelFactory do
  context 'unsupported pmml' do
    let(:empty_file) { 'spec/fixtures/empty_file.pmml' }
    let(:unsupported_model) { Scoruby.load_model(empty_file) }
    let(:unsupported_error) { described_class::MODEL_NOT_SUPPORTED_ERROR }

    it 'raises on unsupported model loading' do
      expect { unsupported_model }.to raise_error(unsupported_error)
    end
  end

  context 'random forest pmml' do
    let(:rf_file) { 'spec/fixtures/titanic_rf.pmml' }
    let(:rf_model) { Scoruby.load_model(rf_file) }

    it 'loads random forest' do
      expect(rf_model).to be_a(Scoruby::Models::RandomForest::Model)
    end
  end

  context 'gbm pmml' do
    context 'pmml 4.2' do
      let(:gbm_file) { 'spec/fixtures/titanic_gbm_4_2.pmml' }
      let(:gbm_model) { Scoruby.load_model(gbm_file) }

      it 'loads gbm' do
        expect(gbm_model).to be_a(Scoruby::Models::GradientBoostedModel::Model)
      end
    end

    context 'pmml 4.3' do
      let(:gbm_file) { 'spec/fixtures/titanic_gbm.pmml' }
      let(:gbm_model) { Scoruby.load_model(gbm_file) }

      it 'loads gbm' do
        expect(gbm_model).to be_a(Scoruby::Models::GradientBoostedModel::Model)
      end
    end
  end

  context 'naive_bayes pmml' do
    let(:naive_bayes_file) { 'spec/fixtures/naive_bayes.pmml' }
    let(:naive_bayes_model) { Scoruby.load_model(naive_bayes_file) }

    it 'loads NaiveBayes' do
      expect(naive_bayes_model).to be_a Scoruby::Models::NaiveBayes::Model
    end
  end

  context 'logistic_regression pmml' do
    let(:logistic_regression_file) { 'spec/fixtures/logistic_regression.pmml' }
    let(:logistic_regression_model) { Scoruby.load_model(logistic_regression_file) }

    it 'loads LogisticRegression' do
      expect(logistic_regression_model).to be_a Scoruby::Models::LogisticRegression::Model
    end
  end
end
