module Scoruby
  module Predicates
    class TruePredicate
      def field
        nil
      end

      def true?(_)
        true
      end

      def is_missing?(_)
        false
      end
    end
  end
end
