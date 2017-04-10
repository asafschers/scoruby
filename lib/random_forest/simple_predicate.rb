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
    return if @operator == IS_MISSING
    @value = attributes['value'].value 
  end

  def true?(features)
    return num_true?(features) if [GREATER_THAN, LESS_OR_EQUAL].include?(@operator)

    return features[@field] == @value if @operator == EQUAL
    features[field].nil? || !features.has_key?(field) if @operator == IS_MISSING
  end

  def num_true?(features)
    curr_value = Float(features[@field])
    value = Float(@value)
    return curr_value > value if @operator == GREATER_THAN
    curr_value < value if @operator == LESS_OR_EQUAL
  end
end