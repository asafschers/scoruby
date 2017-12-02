# frozen_string_literal: true

module Scoruby
  class Decision
    attr_reader :score, :score_distribution

    def initialize(score, score_distributions)
      @score = score
      return if score_distributions.empty?

      @score_distribution = {}
      score_distributions.each do |score_distribution|
        value = score_distribution.attributes['value'].to_s
        probability = score_distribution.attributes['probability'].to_s
        @score_distribution[value] = probability
      end
    end
  end
end
