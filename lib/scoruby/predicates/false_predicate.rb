# frozen_string_literal: true

module Scoruby
  module Predicates
    class FalsePredicate
      def field
        nil
      end

      def true?(_)
        false
      end

      def missing?(_)
        false
      end
    end
  end
end