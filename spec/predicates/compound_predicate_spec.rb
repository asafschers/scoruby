require 'spec_helper'

describe CompoundPredicate do

  context 'evaluates and' do
    let (:pred_string) { p <<-XML
          <CompoundPredicate booleanOperator="and"><True /><SimplePredicate field="f" operator="lessOrEqual" value="16.0918513223731" /></CompoundPredicate>
    XML
    }
    let (:pred_xml) { Nokogiri::XML(pred_string); }
    let (:predicate) { CompoundPredicate.new(pred_xml.children.first) }

    it 'returns true' do
      expect(predicate.true?(f: 16)).to eq true
    end

    it 'returns false' do
      expect(predicate.true?(f: 17)).to eq false
    end
  end

  context 'evaluates or' do
    let (:pred_string) { p <<-XML
          <CompoundPredicate booleanOperator="or"><False /><SimplePredicate field="f" operator="lessOrEqual" value="16.0918513223731" /></CompoundPredicate>
    XML
    }
    let (:pred_xml) { Nokogiri::XML(pred_string); }
    let (:predicate) { CompoundPredicate.new(pred_xml.children.first) }

    it 'returns true' do
      expect(predicate.true?(f: 16)).to eq true
    end

    it 'returns false' do
      expect(predicate.true?(f: 17)).to eq false
    end
  end

  context 'evaluates surrogate' do

  end
end