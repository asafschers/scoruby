# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::LogisticRegression::Data do
  let(:xml) { Scoruby.xml_from_file_path(logistic_regression_file) }
  let(:logistic_regression_file) { 'spec/fixtures/logistic_regression.pmml' }
  let(:data) { described_class.new(xml) }

  # it 'loads correct number of trees' do
  #   expect(data.decision_trees.count).to eq 15
  # end
  #
  it 'loads correct number of coefficient values' do
    expect(data.coefficient_values.count).to eq 3
  end

  it 'loads correct number of coefficient labels' do
    expect(data.coefficient_labels.count).to eq 3
  end

  it 'loads correct number of coefficients' do
    puts data.coefficients
    expect(data.coefficients.count).to eq 3
  end
end
