class CategoricalPredicate

  IS_IN = 'isIn'

  def initialize(pred_xml)
    @field = pred_xml.xpath('@field')
    @array = pred_xml.xpath('Array/text()').to_s.tr('"', '').split('   ')
    @operator = pred_xml.xpath('@booleanOperator')
  end

  def true?(features)
    @array.include? features[@field] if @operator == IS_IN
  end

end