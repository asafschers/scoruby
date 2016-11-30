class CategoricalPredicate

  IS_IN = 'isIn'

  def initialize(pred_xml)
    @field = pred_xml.xpath('@field').to_s.to_sym
    @array = pred_xml.xpath('Array/text()').to_s.tr('"', '').split('   ')
    @operator = pred_xml.xpath('@booleanOperator').to_s
  end

  def true?(features)
    return if missing_feature?(features)
    return if nil_feature?(features)
    @array.include? features[@field] if @operator == IS_IN
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