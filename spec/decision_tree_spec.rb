require 'spec_helper'

describe DecisionTree do

  SHOULD_APPROVE ||= 'should_approve'
  SHOULD_DECLINE ||= 'should_decline'

  let(:tree_file) { 'spec/fixtures/pmml_tree.pmml' }
  let(:tree_xml) { RandomForester.xml_from_file_path(tree_file) }
  let(:decision_tree) { DecisionTree.new(tree_xml.child) }

  context 'sets tree' do

    let (:lr_node) { decision_tree.root.left.right }
    let (:lrlr_node) { lr_node.left.right }
    let (:node_xml) { '<SimplePredicate field="f44" operator="greaterThan" value="3.01028050880094"/>' }
    let (:leaf_xml) { '<SimplePredicate field="f33" operator="greaterThan" value="18.8513846048894"/>' }

    it 'sets node' do
      expect(lr_node.to_s).to eq node_xml
      expect(lr_node.decision.to_s).to eq ''
      expect([lr_node.left, lr_node.right]).to all( be_a Node )
    end

    it 'sets leave' do
      expect(lrlr_node.to_s).to eq leaf_xml
      expect(lrlr_node.decision.to_s).to eq SHOULD_DECLINE
      expect([lrlr_node.left, lrlr_node.right]).to all(be_nil)
    end
  end

  context 'decides' do

    it 'approve' do
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 4)).to eq SHOULD_APPROVE
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 5, f11: 1000000)).to eq SHOULD_APPROVE
    end

    it 'decline' do
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 19)).to eq SHOULD_DECLINE
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 5, f11: 1)).to eq SHOULD_DECLINE
    end

    it 'nils' do
      expect(RandomForester.logger).to receive(:error).twice.with('Missing feature f36')
      expect(RandomForester.logger).to receive(:error).with('Null tree: 4, bad feature: f36')
      expect(decision_tree.decide(f44: 300, f22: 500)).to be_nil
    end
  end

end
