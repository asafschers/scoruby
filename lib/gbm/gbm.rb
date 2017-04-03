require 'gbm_decision_tree'

class Gbm
  GBM_FOREST_XPATH = '//Segmentation[@multipleModelMethod="sum"]/Segment'

  def initialize(xml)

    @gbm_forest = RandomForest.new(xml,GbmDecisionTree,GBM_FOREST_XPATH)


  end

  def tree_count
    @gbm_forest.tree_count
  end

  def score(features)
    # TODO: spec + code
  end
end