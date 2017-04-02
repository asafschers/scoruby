require 'predicate'

class Node

  attr_reader :decision, :left, :right, :pred

  def initialize(xml)
    children = xml.children
    @pred = Predicate.new(children[0])

    @decision = xml.attribute('score').to_s

    return if children.count == 1
    @left = Node.new(children[1]) if children[1]
    @right = Node.new(children[2]) if children[2]
  end

  def true?(features)
    @pred.nil? || @pred.true?(features)
  end
end