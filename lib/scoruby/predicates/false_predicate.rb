module Scoruby
  module Predicates
    class FalsePredicate
      def field
        nil
      end

      def true?(_)
        false
      end

      def is_missing?(_)
        false
      end
    end
  end
end