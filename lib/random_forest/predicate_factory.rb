class PredicateFactory

  def self.for(pred_xml)
    return SimplePredicate.new(pred_xml) if pred_xml.name == 'SimplePredicate'
    return SimpleSetPredicate.new(pred_xml) if pred_xml.name == 'SimpleSetPredicate'
    return CompoundPredicate.new(pred_xml) if pred_xml.name == 'CompoundPredicate'
  end
end