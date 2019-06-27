# frozen_string_literal: true

require 'spec_helper'
require 'scoruby/models/support_vector_machine/data'

describe Scoruby::Models::SupportVectorMachine::Data do
  let(:svm_file) { 'spec/fixtures/support_vector_machine.pmml' }
  let(:xml) { Scoruby.xml_from_file_path(svm_file) }
  let(:data) { described_class.new(xml) }

  it 'reads coefficients from XML' do
    expect(data.coefficients).to match_array [-1, 1, 1, -1]
  end
end
