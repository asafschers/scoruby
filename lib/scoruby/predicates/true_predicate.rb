# frozen_string_literal: true

module Scoruby
  module Predicates
    class TruePredicate
      def field
        nil
      end

      def true?(_)
        true
      end

      def missing?(_)
        false
      end
    end
  end
end
