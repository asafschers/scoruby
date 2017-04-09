class IsMissingPredicate

  attr_reader :field

  def initialize(attributes)
    @field = attributes['field'].value.to_sym
    @operator = attributes['operator'].value
  end

  def true?(features)
    false
  end
end