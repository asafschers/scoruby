# frozen_string_literal: true

module Scoruby
  class Decision
    attr_reader :score, :score_distribution

    def initialize(xml)
      children = xml.children
      distributions = children.select { |c| c.name == 'ScoreDistribution' }

      @score = xml.attribute('score').to_s
      return if distributions.empty?

      @score_distribution = {}
      distributions.each do |score_distribution|
        value = score_distribution.attributes['value'].to_s
        @score_distribution[value] = probability(score_distribution, xml)
      end
    end

    def probability(score_distribution, xml)
      probability = score_distribution.attributes['probability'].to_s
      return probability.to_f if probability != ''
      record_count(score_distribution) / record_count(xml)
    end

    def record_count(xml)
      xml.attributes['recordCount'].to_s.to_f
    end
  end
end
