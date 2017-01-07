class CategoricalPredicate

  IS_IN = 'isIn'

  attr_reader :field

  def initialize(pred_xml)
    @field = pred_xml.xpath('@field').to_s.to_sym
    @array = pred_xml.xpath('Array/text()').to_s.tr('"', '').split('   ')
    @operator = pred_xml.xpath('@booleanOperator').to_s
  end

  def true?(features)
    format_boolean(features)
    @array.include? features[@field] if @operator == IS_IN
  end

  def format_boolean(features)
    features[@field] = 'f' if features[@field] == false
    features[@field] = 't' if features[@field] == true
  end
end