require 'spec_helper'

describe GbmDecisionTree do

  let(:tree_file) { 'spec/fixtures/gbm_tree.pmml' }
  let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
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
      expect(lr_node.score).to eq 0.0011015286521365208
      expect([lr_node.left, lr_node.right]).to all(be_nil)
    end
  end

  context 'scores' do

    it 'without features' do
      features = {}
      expect(decision_tree.decide(features)).to eq 4.3463944950723456E-4
    end

    it 'f2 first true' do
      features = { f2: 'f2v1' }
      expect(decision_tree.decide(features)).to eq -1.8361380219689046E-4
    end

    it 'f1 and f2 first true' do
      features = {f2: 'f2v1', f1: 'f1v3' }
      expect(decision_tree.decide(features)).to eq -6.237581139073701E-4
    end

    it 'f1, f2, f4 first true' do
      features = { f2: 'f2v1', f1: 'f1v3', f4: 0.08 }
      expect(decision_tree.decide(features)).to eq 0.00219682947123581943
    end

    it 'f1, f2 first true f4 second true' do
      features = { f2: 'f2v1', f1: 'f1v3', f4: 0.09 }
      expect(decision_tree.decide(features)).to eq -9.198573460887271E-4
    end

    it 'f1, f2, f3 first true, f4 second true' do
      features = { f2: 'f2v1', f1: 'f1v3', f4: 0.09, f3: 'f3v2' }
      expect(decision_tree.decide(features)).to eq -0.0021187239505556523
    end

    it 'f1, f2 first true f3, f4 second true' do
      features = { f2: 'f2v1', f1: 'f1v3', f4: 0.09, f3: 'f3v4' }
      expect(decision_tree.decide(features)).to eq -3.3516227414227926E-4
    end

    it 'f2 first true f1 second true' do
      features = { f2: 'f2v1', f1: 'f1v4' }
      expect(decision_tree.decide(features)).to eq 0.0011015286521365208
    end

    it 'f2 second true' do
      features = { f2: 'f2v4' }
      expect(decision_tree.decide(features)).to eq 0.0022726641744997256
    end

    it 'f2 none are true' do
      features = { f2: 'f2v9' }
      expect(Scoruby.logger).to receive(:error).with('Null tree: 2532, bad feature: f2')
      expect(decision_tree.decide(features)).to be_nil
    end
  end
end
