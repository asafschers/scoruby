class CategoricalPredicate

  def initialize(pred_xml)
    @Array = pred_xml.xpath('Array')
    @operator = pred_xml.xpath('@booleanOperator')
  end

  def true?(features)
    puts @Array
    puts @operator
  end

end