# frozen_string_literal: true

require 'spec_helper'
require 'scoruby/models/naive_bayes/model'

describe Scoruby::Models::NaiveBayes::Model do
  let(:naive_bayes_file) { 'spec/fixtures/naive_bayes.pmml' }
  let(:xml) { Scoruby.xml_from_file_path(naive_bayes_file) }
  let(:naive_bayes) { described_class.new(xml) }
  let(:features) do
    {
      'age of individual': '24',
      'gender': 'male',
      'no of claims': '2',
      'domicile': nil,
      'age of car': '1'
    }
  end

  let(:l0) { 8723 * 0.001 * 4273 / 8598 * 225 / 8561 * 830 / 8008 }
  let(:l1) do
    2557 * (Math.exp(-(24 - 24.936)**2 / (2 * 0.516)) /
      Math.sqrt(Math::PI * 2 * 0.516)) * 1321 / 2533 * 10 / 2436 * 182 / 2266
  end
  let(:l2) do
    1530 * (Math.exp(-(24 - 24.588)**2 / (2 * 0.635)) /
      Math.sqrt(Math::PI * 2 * 0.635)) * 780 / 1522 * 9 / 1496 * 51 / 1191
  end
  let(:l3) do
    709 * (Math.exp(-(24 - 24.428)**2 / (2 * 0.379)) /
      Math.sqrt(Math::PI * 2 * 0.379)) * 405 / 697 * 0.001 * 26 / 699
  end
  let(:l4) do
    100 * (Math.exp(-(24 - 24.770)**2 / (2 * 0.314)) /
      Math.sqrt(Math::PI * 2 * 0.314)) * 42 / 90 * 10 / 98 * 6 / 87
  end
  let(:lvalues) { naive_bayes.lvalues(features) }
  let(:l2_probability) { naive_bayes.score(features, '1000') }

  it 'calculates lvalues by http://dmg.org/pmml/v4-2-1/NaiveBayes.html' do
    expect(lvalues['100']).to be_within(0.0001).of l0
    expect(lvalues['500']).to be_within(0.0001).of l1
    expect(lvalues['1000']).to be_within(0.0001).of l2
    expect(lvalues['5000']).to be_within(0.0001).of l3
    expect(lvalues['10000']).to be_within(0.0001).of l4
  end

  let(:score) { (l2 / (l0 + l1 + l2 + l3 + l4)) }

  it 'scores by http://dmg.org/pmml/v4-2-1/NaiveBayes.html' do
    expect(l2_probability).to be_within(0.0001).of score
  end
end
