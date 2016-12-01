class NumericalPredicate

  GREATER_THAN = 'greaterThan'
  LESS_OR_EQUAL = 'lessOrEqual'

  attr_reader :field

  def initialize(pred_xml)
    @field = pred_xml.xpath('@field').to_s.to_sym
    @value = pred_xml.xpath('@value').to_s.to_i
    @operator = pred_xml.xpath('@operator').to_s
  end

  def true?(features)
    return @value > features[@field] if @operator == GREATER_THAN
    @value < features[@field] if @operator == LESS_OR_EQUAL
  end
end