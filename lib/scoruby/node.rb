require 'predicate_factory'
require 'decision'

module Scoruby
  class Node

    attr_reader :decision, :pred, :children

    def initialize(xml)
      children = xml.children

      @decision = Scoruby::Decision.new(xml.attribute('score').to_s,
        children.select {|c| c.name == 'ScoreDistribution'})

      children = remove_nodes(children)

      pred_xml  = children[0]
      @pred     = Scoruby::PredicateFactory.for(pred_xml)
      @children = []

      return if children.count == 1

      @children << Scoruby::Node.new(children[1]) if children[1]
      @children << Scoruby::Node.new(children[2]) if children[2]
      @children << Scoruby::Node.new(children[3]) if children[3]
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