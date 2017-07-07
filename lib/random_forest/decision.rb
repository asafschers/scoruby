class Decision

  attr_reader :score, :score_distribution

  def initialize(score, score_distribution)
    @score = score
    @score_distribution = score_distribution
  end
end