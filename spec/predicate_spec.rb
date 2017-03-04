require 'spec_helper'

describe Predicate do

  let (:pred_string) { '<SimplePredicate field="f33" operator="lessOrEqual" value="18.8513846048894"/>' }
  let (:pred_xml) { Nokogiri::XML(pred_string); }
  let (:predicate) { Predicate.new(pred_xml.children[0], 0) }

  it 'logs missing feature' do
    expect(RandomForester.logger).to receive(:error).with('Missing feature f33')
    predicate.true?({})
  end

  it 'logs nil feature' do
    expect(RandomForester.logger).to receive(:error).with('Feature f33 value is nil')
    predicate.true?({f33: nil})
  end

end