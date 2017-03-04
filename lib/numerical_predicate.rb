class NumericalPredicate

  GREATER_THAN = 'greaterThan'
  LESS_OR_EQUAL = 'lessOrEqual'

  attr_reader :field

  def initialize(pred_xml)
    attributes = pred_xml.attributes
    @field = attributes['field'].value.to_sym
    @value = Float(attributes['value'].value)
    @operator = attributes['operator'].value
  end

  def true?(features)
    curr_value = Float(features[@field])
    return curr_value > @value if @operator == GREATER_THAN
    curr_value < @value if @operator == LESS_OR_EQUAL
  end
end