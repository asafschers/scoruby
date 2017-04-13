require 'gbm_predicate'

class GbmNode

  attr_reader :score, :missing, :left, :right, :pred

  def initialize(xml)
    children = xml.children
    @pred = GbmPredicate.new(children[0])

    @score = xml.attribute('score').to_s.to_f unless xml.attribute('score').to_s.empty?

    return if children.count == 1
    @missing = GbmNode.new(children[1]) if children[1]
    @left = GbmNode.new(children[2]) if children[2]
    @right = GbmNode.new(children[3]) if children[3]
  end

  def true?(features)
    @pred.nil? || @pred.true?(features)
  end

end