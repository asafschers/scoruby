class NumericalPredicate

  GREATER_THAN = 'greaterThan'
  LESS_OR_EQUAL = 'lessOrEqual'


  def initialize(pred_xml)
    @field = pred_xml.xpath('@field').to_s.to_sym
    @value = pred_xml.xpath('@value').to_s.to_i
    @operator = pred_xml.xpath('@operator').to_s
  end

  def true?(features)
    return if missing_feature?(features)
    return if nil_feature?(features)
    return @value > features[@field] if @operator == GREATER_THAN
    @value < features[@field] if @operator == LESS_OR_EQUAL
  end

  def missing_feature?(features)
    return false if features.has_key? @field
    RandomForester.logger.error "Missing feature #{@field}"
    true
  end

  def nil_feature?(features)
    return false unless features[@field].nil?
    RandomForester.logger.error "Feature #{@field} value is nil"
    true
  end

end