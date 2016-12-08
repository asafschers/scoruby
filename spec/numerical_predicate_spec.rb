require 'spec_helper'

describe NumericalPredicate do

  let (:pred_string) { '<SimplePredicate field="f33" operator="lessOrEqual" value="18.8513846048894"/>' }
  let (:pred_xml) { Nokogiri::XML(pred_string); }
  let (:relevant_pred_xml) {  pred_xml.xpath('*') }
  let (:numerical_predicate) { NumericalPredicate.new(relevant_pred_xml) }

  it 'returns true' do
    expect(numerical_predicate.true?(f33: 18)).to eq true
  end

  it 'returns false' do
    expect(numerical_predicate.true?(f33: 19)).to eq false
  end

end