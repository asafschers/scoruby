require 'simple_predicate'
require 'simple_set_predicate'

class Node

  attr_reader :decision, :pred, :children 

  def initialize(xml)
    children = xml.children
    pred_xml = children[0]
    @pred = SimplePredicate.new(pred_xml) if pred_xml.name == 'SimplePredicate'
    @pred = SimpleSetPredicate.new(pred_xml) if pred_xml.name == 'SimpleSetPredicate'
    @children = []
    @decision = xml.attribute('score').to_s

    return if children.count == 1

    @children << Node.new(children[1]) if children[1]
    @children << Node.new(children[2]) if children[2]
    @children << Node.new(children[3]) if children[3]
  end

  def true?(features)
    @pred.nil? || @pred.true?(features)
  end
end