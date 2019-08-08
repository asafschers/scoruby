# frozen_string_literal: true

require 'scoruby/node'

module Scoruby
  module Models
    class DecisionTree
      attr_reader :root

      def initialize(tree_xml)
        @id   = tree_xml.attribute('id')
        @root = Node.new(tree_xml.at_xpath('TreeModel/Node'))
      end

      def decide(features)
        curr = @root
        while curr.children[0]
          prev = curr
          curr = step(curr, features)
          break if didnt_step?(curr, prev)
        end

        curr.decision
      end

      private

      def step(curr, features)
        return curr unless curr.children
        next_step = curr.children.find { |c| c && c.true?(features) }
        next_step || curr
      end

      def didnt_step?(curr, prev)
        return false if prev.pred != curr.pred
        feature = curr.children[0].pred.field
        Scoruby.logger.error "Null tree: #{@id}, bad feature: #{feature}"
        true
      end
    end
  end
end
