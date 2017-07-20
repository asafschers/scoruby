require 'scoruby/predicate_factory'
require 'scoruby/decision'

module Scoruby
  class Node

    attr_reader :decision, :pred, :children

    def initialize(xml)
      children = xml.children

      @decision = Decision.new(xml.attribute('score').to_s,
        children.select {|c| c.name == 'ScoreDistribution'})

      children = remove_nodes(children)

      pred_xml  = children[0]
      @pred     = PredicateFactory.for(pred_xml)
      @children = []

      return if children.count == 1

      @children << Node.new(children[1]) if children[1]
      @children << Node.new(children[2]) if children[2]
      @children << Node.new(children[3]) if children[3]
      @children << Node.new(children[4]) if children[4]
      @children << Node.new(children[5]) if children[5]
      @children << Node.new(children[6]) if children[6]
      @children << Node.new(children[7]) if children[7]
      @children << Node.new(children[8]) if children[8]
      @children << Node.new(children[9]) if children[9]
      @children << Node.new(children[10]) if children[10]
    end

    def true?(features)
      @pred.nil? || @pred.true?(features)
    end

    private

    def remove_nodes(children)
      children.reject {|c| %w(Extension ScoreDistribution).include? c.name}
    end
  end
end