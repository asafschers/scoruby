require 'spec_helper'

describe GbmDecisionTree do

  let(:tree_file) { 'spec/fixtures/gbm_tree.pmml' }
  let(:tree_xml) { RandomForester.xml_from_file_path(tree_file) }
  let(:decision_tree) { GbmDecisionTree.new(tree_xml.child) }

  context 'sets tree' do

    let (:l_node) { decision_tree.root.left }
    let (:lr_node) { l_node.right }

    it 'sets node' do
      expect(l_node.pred.field).to eq :f2
      expect(l_node.score.to_s).to eq ''
      expect([l_node.left, l_node.right]).to all( be_a GbmNode )
    end

    it 'sets leave' do
      expect(lr_node.pred.field).to eq :f1
      expect(lr_node.score.to_s).to eq '0.0011015286521365208'
      expect([lr_node.left, lr_node.right]).to all(be_nil)
    end
  end

  # context 'decides' do
  #
  #   it 'approve' do
  #     expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 4)).to eq SHOULD_APPROVE
  #     expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 5, f11: 1000000)).to eq SHOULD_APPROVE
  #   end
  #
  #   it 'decline' do
  #     expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 19)).to eq SHOULD_DECLINE
  #     expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 5, f11: 1)).to eq SHOULD_DECLINE
  #   end
  #
  #   it 'nils' do
  #     expect(RandomForester.logger).to receive(:error).twice.with('Missing feature f36')
  #     expect(RandomForester.logger).to receive(:error).with('Null tree: 4, bad feature: f36')
  #     expect(decision_tree.decide(f44: 300, f22: 500)).to be_nil
  #   end
  # end

end
