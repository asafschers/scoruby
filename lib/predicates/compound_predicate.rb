class CompoundPredicate

  attr_reader :field

  def initialize(pred_xml)
    attributes = pred_xml.attributes
    children = pred_xml.children

    @boolean_operator = attributes['booleanOperator'].value
    @predicates = []
    @predicates << PredicateFactory.for(children[0])
    @predicates << PredicateFactory.for(children[1])
    @field = @predicates.map(&:field).flatten.compact
  end

  def true?(features)
    return surrogate?(features) if @boolean_operator == 'surrogate'
    return or?(features) if @boolean_operator == 'or'
    and?(features) if @boolean_operator == 'and'
  end

  def is_missing?(features)
    @field.any? { |f| !features.keys.include?(f) }
  end

  private

  def surrogate?(features)
    return @predicates[1].true?(features) if @predicates[0].is_missing?(features)
    @predicates[0].true?(features)
  end

  def or?(features)
    @predicates.any? { |p| p.true?(features) }
  end

  def and?(features)
    @predicates.all? { |p| p.true?(features) }
  end
end