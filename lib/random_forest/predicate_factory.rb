require 'compound_predicate'
require 'simple_predicate'
require 'simple_set_predicate'

class PredicateFactory

  def self.for(pred_xml)
    return SimplePredicate.new(pred_xml) if pred_xml.name == 'SimplePredicate'
    return SimpleSetPredicate.new(pred_xml) if pred_xml.name == 'SimpleSetPredicate'
    return CompoundPredicate.new(pred_xml) if pred_xml.name == 'CompoundPredicate'
    return TruePredicate.new if pred_xml.name == 'True'
    return FalsePredicate.new if pred_xml.name == 'False'
  end
end

class TruePredicate
  def field
    nil
  end

  def true?(_)
    true
  end
end

class FalsePredicate
  def field
    nil
  end

  def true?(_)
    false
  end
end

