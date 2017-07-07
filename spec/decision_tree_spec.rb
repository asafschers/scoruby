require 'spec_helper'

describe DecisionTree do

  SHOULD_APPROVE ||= 'should_approve'
  SHOULD_DECLINE ||= 'should_decline'

  let(:tree_file) { 'spec/fixtures/pmml_tree.pmml' }
  let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
  let(:decision_tree) { DecisionTree.new(tree_xml.child) }

  context 'sets tree' do

    let (:lr_node) { decision_tree.root.children[0].children[1] }
    let (:lrlr_node) { lr_node.children[0].children[1] }
    let (:node_xml) { '<SimplePredicate field="f44" operator="greaterThan" value="3.01028050880094"/>' }
    let (:leaf_xml) { '<SimplePredicate field="f33" operator="greaterThan" value="18.8513846048894"/>' }

    it 'sets node' do
      expect(lr_node.pred.field).to eq :f44
      expect(lr_node.decision.score).to eq ''
      expect([lr_node.children[0], lr_node.children[1]]).to all( be_a Node )
    end

    it 'sets leave' do
      expect(lrlr_node.pred.field).to eq :f33
      expect(lrlr_node.decision.score).to eq SHOULD_DECLINE
      expect([lrlr_node.children[0], lrlr_node.children[1]]).to all(be_nil)
    end
  end

  context 'decides' do

    it 'approve' do
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 4).score).to eq SHOULD_APPROVE
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 5, f11: 1000000).score).to eq SHOULD_APPROVE
    end

    it 'decline' do
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 19).score).to eq SHOULD_DECLINE
      expect(decision_tree.decide(f36: 'FL', f44: 4, f5: 'iPhone', f33: 18, f1: 5, f11: 1).score).to eq SHOULD_DECLINE
    end

    it 'nils' do
      expect(Scoruby.logger).to receive(:error).with('Null tree: 4, bad feature: f36')
      expect(decision_tree.decide(f44: 300, f22: 500)).to be_nil
    end
  end

  context 'gbm tree' do

    let(:tree_file) { 'spec/fixtures/gbm_tree.pmml' }
    let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
    let(:decision_tree) { DecisionTree.new(tree_xml.child) }

    context 'sets tree' do

      let (:l_node) { decision_tree.root.children[1] }
      let (:lr_node) { l_node.children[2] }

      it 'sets node' do
        expect(l_node.pred.field).to eq :f2
        expect(l_node.decision.score).to eq ''
        expect(lr_node.children).to all( be_a Node )
      end

      it 'sets leave' do
        expect(lr_node.pred.field).to eq :f1
        expect(lr_node.decision.score).to eq '0.0011015286521365208'
        expect(lr_node.children).to all(be_nil)
      end
    end

    context 'scores' do

      it 'without features' do
        features = {}
        expect(decision_tree.decide(features).score).to eq '4.3463944950723456E-4'
      end

      it 'f2 first true' do
        features = { f2: 'f2v1' }
        expect(decision_tree.decide(features).score).to eq '-1.8361380219689046E-4'
      end

      it 'f1 and f2 first true' do
        features = {f2: 'f2v1', f1: 'f1v3' }
        expect(decision_tree.decide(features).score).to eq '-6.237581139073701E-4'
      end

      it 'f1, f2, f4 first true' do
        features = { f2: 'f2v1', f1: 'f1v3', f4: 0.08 }
        expect(decision_tree.decide(features).score).to eq '0.0021968294712358194'
      end

      it 'f1, f2 first true f4 second true' do
        features = { f2: 'f2v1', f1: 'f1v3', f4: 0.09 }
        expect(decision_tree.decide(features).score).to eq '-9.198573460887271E-4'
      end

      it 'f1, f2, f3 first true, f4 second true' do
        features = { f2: 'f2v1', f1: 'f1v3', f4: 0.09, f3: 'f3v2' }
        expect(decision_tree.decide(features).score).to eq '-0.0021187239505556523'
      end

      it 'f1, f2 first true f3, f4 second true' do
        features = { f2: 'f2v1', f1: 'f1v3', f4: 0.09, f3: 'f3v4' }
        expect(decision_tree.decide(features).score).to eq '-3.3516227414227926E-4'
      end

      it 'f2 first true f1 second true' do
        features = { f2: 'f2v1', f1: 'f1v4' }
        expect(decision_tree.decide(features).score).to eq '0.0011015286521365208'
      end

      it 'f2 second true' do
        features = { f2: 'f2v4' }
        expect(decision_tree.decide(features).score).to eq '0.0022726641744997256'
      end

      it 'f2 none are true' do
        features = { f2: 'f2v9' }
        expect(Scoruby.logger).to receive(:error).with('Null tree: 2532, bad feature: f2')
        expect(decision_tree.decide(features)).to be_nil
      end
    end
  end

  context 'decision tree' do

    let(:tree_file) { 'spec/fixtures/decision_tree.pmml' }
    let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
    let(:decision_tree) { DecisionTree.new(tree_xml.child) }

    # TODO: finish and spec compound predicate
    # TODO: ScoreDistribution

    it 'scores' do
      #expect(decision_tree.decide(ppd: 9.536082).score).to eq 0.000487
      #expect(decision_tree.decide(ppd: 51.490066)).to eq 0.000289
    end
  end
end
