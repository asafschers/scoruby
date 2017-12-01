require 'spec_helper'

describe Scoruby::Predicates::CompoundPredicate do
  context 'evaluates and' do
    let(:pred_string) do
      <<-XML
        <CompoundPredicate booleanOperator="and"><True /><SimplePredicate field="f" operator="lessOrEqual" value="16.0918513223731" /></CompoundPredicate>
      XML
    end

    let(:pred_xml) { Nokogiri::XML(pred_string); }
    let(:predicate) { described_class.new(pred_xml.children.first) }

    it 'returns true' do
      expect(predicate.true?(f: 16)).to eq true
    end

    it 'returns false' do
      expect(predicate.true?(f: 17)).to eq false
    end
  end

  context 'evaluates or' do
    let(:pred_string) do
      <<-XML
        <CompoundPredicate booleanOperator="or"><False /><SimplePredicate field="f" operator="lessOrEqual" value="16.0918513223731" /></CompoundPredicate>
      XML
    end

    let(:pred_xml) { Nokogiri::XML(pred_string); }
    let(:predicate) { described_class.new(pred_xml.children.first) }

    it 'returns true' do
      expect(predicate.true?(f: 16)).to eq true
    end

    it 'returns false' do
      expect(predicate.true?(f: 17)).to eq false
    end
  end

  context 'evaluates surrogate' do
    context 'simple predicate' do
      let(:pred_string) do
        <<-XML
          <CompoundPredicate booleanOperator="surrogate"><SimplePredicate field="f" operator="lessOrEqual" value="16.0918513223731" /><False /></CompoundPredicate>
        XML
      end
      let(:pred_xml) { Nokogiri::XML(pred_string); }
      let(:predicate) { described_class.new(pred_xml.children.first) }

      it 'missing' do
        expect(predicate.true?(g: 17)).to eq false
      end

      it 'not missing' do
        expect(predicate.true?(f: 16)).to eq true
      end
    end
  end
end
