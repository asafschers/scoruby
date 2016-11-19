require 'spec_helper'

describe DecisionTree do

  RF_FILE = 'rf_file'
  NON_RF_FILE = 'non_rf_file'

  let(:tree_file) { 'spec/fixtures/pmml_tree.pmml' }
  let(:tree_xml) { RandomForester.get_xml(tree_file) }
  let(:decision_tree) { DecisionTree.new(tree_xml) }

  context 'sets tree' do

    let (:lr_node) { decision_tree.root[DecisionTree::LEFT][DecisionTree::RIGHT] }
    let (:lrlr_node) { lr_node['left']['right'] }
    let (:node_xml) { '<SimplePredicate field="f44" operator="greaterThan" value="3.01028050880094"/>' }
    let (:leave_xml) { '<SimplePredicate field="f33" operator="greaterThan" value="18.8513846048894"/>' }

    it 'sets node' do
      expect(lr_node.content.to_s).to eq node_xml
      expect(lr_node.content.decision.to_s).to eq ''
      expect(lr_node.is_leaf?).to be false
    end

    it 'sets leave' do
      expect(lrlr_node.content.to_s).to eq leave_xml
      expect(lrlr_node.content.decision.to_s).to eq DecisionTree::SHOULD_DECLINE
      expect(lrlr_node.is_leaf?).to be true
    end
  end

  context 'decides' do

    it 'approve' do
      expect(decision_tree.decide(f44: 3, f22: 5)).to eq DecisionTree::SHOULD_APPROVE
    end

    it 'decline' do
      expect(decision_tree.decide(f44: 300, f22: 500)).to eq DecisionTree::SHOULD_DECLINE
    end
  end

end
