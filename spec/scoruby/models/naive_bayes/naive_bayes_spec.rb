require 'spec_helper'
require 'scoruby/models/naive_bayes/model'

describe Scoruby::Models::NaiveBayes::Model do

  let(:naive_bayes_file) { 'spec/fixtures/naive_bayes.pmml'}
  let(:xml) { Scoruby.xml_from_file_path(naive_bayes_file) }
  let(:naive_bayes) { described_class.new(xml) }
  let(:features) do {
      'age of individual': '24',
      'gender': 'male',
      'no of claims': '2',
      'domicile': nil,
      'age of car': '1'
  }
  end

  it 'returns lvalues' do
    puts naive_bayes.lvalues(features)
  end

  it 'scores' do
    puts naive_bayes.score(features, '1000')
  end
end