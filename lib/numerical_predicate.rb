class NumericalPredicate

  def initialize(pred_xml)
    @value = pred_xml.xpath('@value')
    @operator = pred_xml.xpath('@operator')
  end

  def true?(features)
    puts @value
    puts @operator
  end
end