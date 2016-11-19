class CategoricalPredicate

  def initialize(pred_xml)
    @field = pred_xml.xpath('@field')
    @Array = pred_xml.xpath('Array')
    @operator = pred_xml.xpath('@booleanOperator')
  end

  def true?(features)
    # puts @Array
    # puts @operator
    # puts @field
  end

end