# frozen_string_literal: true

require 'spec_helper'

describe Scoruby do
  let(:empty_file) { 'spec/fixtures/empty_file.pmml' }
  let(:unsupported_model) { Scoruby.load_model(empty_file) }
  let(:unsupported_error) { Scoruby::ModelsFactory::MODEL_NOT_SUPPORTED_ERROR }

  it 'raises on unsupported model loading' do
    expect { unsupported_model }.to raise_error(unsupported_error)
  end

  let(:rf_file) { 'spec/fixtures/titanic_rf.pmml' }
  let(:rf_model) { Scoruby.load_model(rf_file) }

  it 'loads random forest' do
    expect(rf_model).to be_a(Scoruby::Models::RandomForest)
  end

  let(:gbm_file) { 'spec/fixtures/gbm_file.pmml' }
  let(:gbm_model) { Scoruby.load_model(gbm_file) }

  it 'loads gbm' do
    expect(gbm_model).to be_a(Scoruby::Models::Gbm)
  end

  let(:naive_bayes_file) { 'spec/fixtures/naive_bayes.pmml' }
  let(:naive_bayes_model) { Scoruby.load_model(naive_bayes_file) }

  it 'loads NaiveBayes' do
    expect(naive_bayes_model).to be_a Scoruby::Models::NaiveBayes::Model
  end
end
