require 'spec_helper'

describe Predicate do

  let (:pred_string) { '<Node id="2"><SimplePredicate field="f33" operator="lessOrEqual" value="18.8513846048894"/></Node>' }
  let (:pred_xml) { Nokogiri::XML(pred_string); }
  let (:relevant_pred_xml) {  pred_xml.xpath('*') }
  let (:predicate) { Predicate.new(relevant_pred_xml) }

  it 'logs missing feature' do
    expect(RandomForester.logger).to receive(:error).with('Missing feature f33')
    predicate.true?({})
  end

  it 'logs nil feature' do
    expect(RandomForester.logger).to receive(:error).with('Feature f33 value is nil')
    predicate.true?({f33: nil})
  end

end