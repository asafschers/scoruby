class CategoricalPredicate

  IS_IN = 'isIn'

  attr_reader :field

  def initialize(pred_xml)
    attributes = pred_xml.attributes
    @field = attributes['field'].value.to_sym
    @array = pred_xml.children[0].content.tr('"', '').split('   ')
    @operator = attributes['booleanOperator'].value
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