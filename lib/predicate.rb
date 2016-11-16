class Predicate

  def initialize(pred_xml)
    @pred_xml = pred_xml
  end

  def to_s
    @pred_xml.xpath('*')[0].to_s
  end

  def decision
    @pred_xml.xpath('@score').to_s
  end

  def true?(features)
    # TODO: implement
    false
  end
end