require 'spec_helper'

describe DecisionTree do

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

  context 'Score distribution' do

    let(:tree_file) { 'spec/fixtures/decision_tree.pmml' }
    let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
    let(:decision_tree) { DecisionTree.new(tree_xml.child) }
    
    it 'scores' do
      expect(decision_tree.decide(ppd: 10).score_distribution).to eq(
                                                                            {'0' => '0.999513428516638', '1' => '0.000486571483361926'})
      expect(decision_tree.decide(ppd: 20).score_distribution).to eq(
                                                                            {'0' => '0.999615579933873', '1' => '0.000384420066126561'})
      expect(decision_tree.decide(ppd: 50).score_distribution).to eq(
                                                                            {'0' => '0.999710889179894', '1' => '0.000289110820105768'})
    end
  end
end
