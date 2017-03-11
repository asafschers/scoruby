require 'spec_helper'

describe CategoricalPredicate do

  let (:pred_string) { '   <SimpleSetPredicate field="f36" booleanOperator="isIn">
    <Array n="6" type="string">"F"   "F1L"   "F1L1"   "FL"   "FL1"   "L"</Array>
   </SimpleSetPredicate>' }
  let (:pred_xml) { RandomForester.xml_from_string(pred_string) }
  let (:relevant_pred_xml) {  pred_xml.children[0] }
  let (:categorical_predicate) { CategoricalPredicate.new(relevant_pred_xml) }

  it 'returns true' do
    expect(categorical_predicate.true?(f36: 'FL')).to eq true
  end

  it 'returns false' do
    expect(categorical_predicate.true?(f36: 'FF')).to eq false
  end

end