class CompoundPredicate

  def initialize(pred_xml)
    attributes = pred_xml.attributes
    children = pred_xml.children

    @boolean_operator = attributes['booleanOperator'].value
    @predicates = []
    @predicates << PredicateFactory.for(children[0])
    @predicates << PredicateFactory.for(children[1])
  end

  def true?(features)
    surrogate?(features) if @boolean_operator == 'surrogate'
    or?(features) if @boolean_operator == 'or'
    and?(features) if @boolean_operator == 'and'
  end

  private

  def surrogate?(features)
    @predicates[0].feature.is_missing?(feautres) return @predicates[1]
    @predicates[0].true?(features)

  end

  def or?(features)
    @predicates.any? { |p| p.true?(features) }
  end

  def and?(features)
    @predicates.all? { |p| p.true?(features) }
  end
end