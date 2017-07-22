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
      
      @pred     = PredicateFactory.for(children[0])
      @children = children_nodes(children)
    end

    def true?(features)
      @pred.nil? || @pred.true?(features)
    end

    private

    def children_nodes(children)
      children.select { |c| c.name == 'Node' }
        .map { |child| Node.new(child) }
    end

    def remove_nodes(children)
      children.reject {|c| %w(Extension ScoreDistribution).include? c.name}
    end
  end
end