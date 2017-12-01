# frozen_string_literal: true

module Scoruby
  module Predicates
    class SimplePredicate

      GREATER_THAN     = 'greaterThan'
      LESS_THAN        = 'lessThan'
      LESS_OR_EQUAL    = 'lessOrEqual'
      GREATER_OR_EQUAL = 'greaterOrEqual'
      MATH_OPS         = [GREATER_THAN, LESS_THAN, LESS_OR_EQUAL, GREATER_OR_EQUAL]
      EQUAL            = 'equal'
      IS_MISSING       = 'isMissing'

      attr_reader :field

      def initialize(pred_xml)
        attributes = pred_xml.attributes

        @field    = attributes['field'].value.to_sym
        @operator = attributes['operator'].value
        return if @operator == IS_MISSING
        @value = attributes['value'].value
      end

      def true?(features)
        return num_true?(features) if MATH_OPS.include?(@operator)
        return features[@field] == @value if @operator == EQUAL
        features[field].nil? || !features.has_key?(field) if @operator == IS_MISSING
      end

      def missing?(features)
        !features.keys.include?(@field)
      end

      private

      def num_true?(features)
        return false unless features[@field]
        curr_value = Float(features[@field])
        value      = Float(@value)
        return curr_value > value if @operator == GREATER_THAN
        return curr_value < value if @operator == LESS_THAN
        return curr_value <= value if @operator == LESS_OR_EQUAL
        curr_value >= value if @operator == GREATER_OR_EQUAL
      end
    end
  end
end
