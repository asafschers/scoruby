# frozen_string_literal: true

module Scoruby
  class Decision

    attr_reader :score, :score_distribution

    def initialize(score, score_distributions)
      @score = score
      return if score_distributions.empty?

      @score_distribution = {}
      score_distributions.each {|score_distribution|
        attributes                                    = score_distribution.attributes
        @score_distribution[attributes['value'].to_s] = attributes['probability'].to_s
      }
    end
  end
end