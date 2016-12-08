class NumericalPredicate

  GREATER_THAN = 'greaterThan'
  LESS_OR_EQUAL = 'lessOrEqual'

  attr_reader :field

  def initialize(pred_xml)
    @field = pred_xml.xpath('@field').to_s.to_sym
    @value = Float(pred_xml.xpath('@value').to_s)
    @operator = pred_xml.xpath('@operator').to_s
  end

  def true?(features)
    curr_value = Float(features[@field])
    return curr_value > @value if @operator == GREATER_THAN
    curr_value < @value if @operator == LESS_OR_EQUAL
  end
end