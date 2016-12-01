class CategoricalPredicate

  IS_IN = 'isIn'

  attr_reader :field

  def initialize(pred_xml)
    @field = pred_xml.xpath('@field').to_s.to_sym
    @array = pred_xml.xpath('Array/text()').to_s.tr('"', '').split('   ')
    @operator = pred_xml.xpath('@booleanOperator').to_s
  end

  def true?(features)
    @array.include? features[@field] if @operator == IS_IN
  end
end