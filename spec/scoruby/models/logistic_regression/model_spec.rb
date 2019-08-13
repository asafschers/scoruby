# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::LogisticRegression::Model do
  let(:logistic_regression_file) { 'spec/fixtures/logistic_regression.pmml' }
  let(:xml) { Scoruby.xml_from_file_path(logistic_regression_file) }
  let(:logistic_regression) { described_class.new(xml) }
  let(:features) do
    {
      'prob' => 0.13,
      'noise_var' => 0.5
    }
  end

  context 'default' do
    it 'scores features' do
      expect(logistic_regression.score(features).round(8)).to eq 0.08243046
    end
  end
end
