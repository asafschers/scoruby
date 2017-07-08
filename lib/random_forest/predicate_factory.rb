require 'predicates/compound_predicate'
require 'predicates/simple_predicate'
require 'predicates/simple_set_predicate'
require 'predicates/true_predicate'
require 'predicates/false_predicate'

class PredicateFactory

  def self.for(pred_xml)
    return SimplePredicate.new(pred_xml) if pred_xml.name == 'SimplePredicate'
    return SimpleSetPredicate.new(pred_xml) if pred_xml.name == 'SimpleSetPredicate'
    return CompoundPredicate.new(pred_xml) if pred_xml.name == 'CompoundPredicate'
    return TruePredicate.new if pred_xml.name == 'True'
    return FalsePredicate.new if pred_xml.name == 'False'
  end
end


