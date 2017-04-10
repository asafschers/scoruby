class SimplePredicate

  GREATER_THAN = 'greaterThan'
  LESS_OR_EQUAL = 'lessOrEqual'
  EQUAL = 'equal'
  IS_MISSING = 'isMissing'

  attr_reader :field

  def initialize(pred_xml)
    attributes = pred_xml.attributes

    @field = attributes['field'].value.to_sym
    @operator = attributes['operator'].value
    return if @operator == 'isMissing'
    @value = @operator == EQUAL ? attributes['value'].value : Float(attributes['value'].value)
  end

  def true?(features)
    curr_value = @operator == EQUAL ? features[@field] : Float(features[@field])
    return curr_value > @value if @operator == GREATER_THAN
    return curr_value < @value if @operator == LESS_OR_EQUAL
    nil_feature?(features) || missing_feature?(features) if @operator == IS_MISSING
  end
end