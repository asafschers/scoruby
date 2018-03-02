# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::DecisionTree do
  let(:tree_file) { 'spec/fixtures/gbm_tree.pmml' }
  let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
  let(:decision_tree) { described_class.new(tree_xml.child) }

  context 'sets tree' do
    let(:l_node) { decision_tree.root.children[1] }
    let(:lr_node) { l_node.children[2] }

    it 'sets node' do
      expect(l_node.pred.field).to eq :f2
      expect(l_node.decision.score).to eq ''
      expect(lr_node.children).to all(be_a Scoruby::Node)
    end

    it 'sets leave' do
      expect(lr_node.pred.field).to eq :f1
      expect(lr_node.decision.score).to eq '0.0011015286521365208'
      expect(lr_node.children).to all(be_nil)
    end
  end

  context 'Score' do
    let(:decision) { decision_tree.decide(features) }
    let(:score) { decision.score }

    context 'without features' do
      let(:features) { {} }
      it 'scores' do
        expect(score).to eq '4.3463944950723456E-4'
      end
    end

    context 'f2 first true' do
      let(:features) { { f2: 'f2v1' } }
      it 'scores' do
        expect(score).to eq '-1.8361380219689046E-4'
      end
    end

    context 'f1, f2  first true' do
      let(:features) { { f2: 'f2v1', f1: 'f1v3' } }
      it 'scores' do
        expect(score).to eq '-6.237581139073701E-4'
      end
    end

    context 'f1, f2, f4  first true' do
      let(:features) { { f2: 'f2v1', f1: 'f1v3', f4: 0.08 } }
      it 'scores' do
        expect(score).to eq '0.0021968294712358194'
      end
    end

    context 'f1, f2 first true f4 second true' do
      let(:features) { { f2: 'f2v1', f1: 'f1v3', f4: 0.09 } }
      it 'scores' do
        expect(score).to eq '-9.198573460887271E-4'
      end
    end

    context 'f1, f2, f3 first true, f4 second true' do
      let(:features) { { f2: 'f2v1', f1: 'f1v3', f4: 0.09, f3: 'f3v2' } }
      it 'scores' do
        expect(score).to eq '-0.0021187239505556523'
      end
    end

    context 'f1, f2 first true f3, f4 second true' do
      let(:features) { { f2: 'f2v1', f1: 'f1v3', f4: 0.09, f3: 'f3v4' } }
      it 'scores' do
        expect(score).to eq '-3.3516227414227926E-4'
      end
    end

    context 'f2 first true f1 second true' do
      let(:features) { { f2: 'f2v1', f1: 'f1v4' } }
      it 'scores' do
        expect(score).to eq '0.0011015286521365208'
      end
    end

    context 'f2 second true' do
      let(:features) { { f2: 'f2v4' } }
      it 'scores' do
        expect(score).to eq '0.0022726641744997256'
      end
    end

    context 'f2 none are true' do
      let(:features) { { f2: 'f2v7' } }
      let(:error) { 'Null tree: 2532, bad feature: f2' }
      it 'scores' do
        expect(Scoruby.logger).to receive(:error).with(error)
        expect(decision).to be_nil
      end
    end
  end

  context 'Score distribution' do
    let(:tree_file) { 'spec/fixtures/decision_tree.pmml' }
    let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
    let(:decision_tree) { described_class.new(tree_xml.child) }
    let(:decision) { decision_tree.decide(ppd: ppd) }
    let(:score_distribution) { decision.score_distribution }

    context 'ppd 10' do
      let(:ppd) { 10 }
      let(:expected) do
        {
          '0' => 0.999513428516638,
          '1' => 0.000486571483361926
        }
      end
      it 'scores' do
        expect(score_distribution).to eq(expected)
      end
    end

    context 'ppd 20' do
      let(:ppd) { 20 }
      let(:expected) do
        {
          '0' => 0.999615579933873,
          '1' => 0.000384420066126561
        }
      end

      it 'scores' do
        expect(score_distribution).to eq(expected)
      end
    end

    context 'ppd 50' do
      let(:ppd) { 50 }
      let(:expected) do
        {
          '0' => 0.999710889179894,
          '1' => 0.000289110820105768
        }
      end

      it 'scores' do
        expect(score_distribution).to eq(expected)
      end
    end
  end

  context 'Score distribution' do
    let(:tree_file) { 'spec/fixtures/binary_split_decision_tree.pmml' }
    let(:tree_xml) { Scoruby.xml_from_file_path(tree_file) }
    let(:decision_tree) { described_class.new(tree_xml.child) }
    let(:features) do
      {
        ppd: ppd,
        business_traveler: business_traveler,
        total_nights: total_nights,
        days_to_booking: days_to_booking,
        percent_distance_avg_price: percent_distance_avg_price
      }
    end
    let(:decision) { decision_tree.decide(features) }
    let(:score_distribution) { decision.score_distribution }

    let(:ppd) { 10 }
    let(:business_traveler) { 0.3 }
    let(:percent_distance_avg_price) { 0.1 }
    let(:total_nights) { 2 }
    let(:days_to_booking) { 6 }
    let(:expected) do
      {
        '0' => 0.4507042253521127,
        '1' => 0.5492957746478874
      }
    end

    it 'scores' do
      expect(score_distribution).to eq(expected)
    end
  end
end
