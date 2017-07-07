class CompoundPredicate
  # TODO: spec

  attr_reader :field

  def initialize(pred_xml)
    attributes = pred_xml.attributes
    children = pred_xml.children

    @boolean_operator = attributes['booleanOperator'].value
    @predicates = []
    @predicates << PredicateFactory.for(children[0])
    @predicates << PredicateFactory.for(children[1])
    @field = @predicates.map(&:field)
  end

  def true?(features)
    return surrogate?(features) if @boolean_operator == 'surrogate'
    return or?(features) if @boolean_operator == 'or'
    and?(features) if @boolean_operator == 'and'
  end

  private

  def surrogate?(features)
    # TODO: return 1 if 0 is missing
    @predicates[0].true?(features)
  end

  def or?(features)
    @predicates.any? { |p| p.true?(features) }
  end

  def and?(features)
    @predicates.all? { |p| p.true?(features) }
  end
end