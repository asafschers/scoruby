require 'spec_helper'
require 'scoruby/models/naive_bayes'

describe Scoruby::Models::NaiveBayes do

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

  it 'scores' do
    puts naive_bayes.score(features)
  end

end