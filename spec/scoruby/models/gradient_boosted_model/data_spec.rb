# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::GradientBoostedModel::Data do
  let(:xml) { Scoruby.xml_from_file_path(gbm_file) }
  let(:gbm) { described_class.new(xml) }

  context 'pmml 4.3' do
    let(:gbm_file) { 'spec/fixtures/titanic_gbm.pmml' }

    it 'loads correct number of trees' do
      expect(gbm.decision_trees.count).to eq 100
    end
  end

  context 'pmml 4.2' do
    let(:gbm_file) { 'spec/fixtures/titanic_gbm_4_2.pmml' }

    it 'loads correct number of trees' do
      expect(gbm.decision_trees.count).to eq 100
    end
  end
end
