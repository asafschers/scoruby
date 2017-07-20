require 'node'

module Scoruby
  module Models
    class DecisionTree

      attr_reader :root

      def initialize(tree_xml)
        @id   = tree_xml.attribute('id')
        @root = Scoruby::Node.new(tree_xml.xpath('TreeModel/Node'))
      end

      def decide(features)
        curr = @root
        while curr.children[0]
          prev = curr
          curr = step(curr, features)
          return if didnt_step?(curr, prev)
        end

        curr.decision
      end

      private

      def step(curr, features)
        curr = step_on_true(curr, features, 0)
        curr = step_on_true(curr, features, 1)
        curr = step_on_true(curr, features, 2)
        curr
      end

      def step_on_true(curr, features, num)
        return curr.children[num] if curr.children && curr.children[num] && curr.children[num].true?(features)
        curr
      end

      def didnt_step?(curr, prev)
        return false if (prev.pred != curr.pred)
        Scoruby.logger.error "Null tree: #{@id}, bad feature: #{curr.children[0].pred.field }"
        true
      end
    end
  end
end
