require 'scoruby/predicates/compound_predicate'
require 'scoruby/predicates/simple_predicate'
require 'scoruby/predicates/simple_set_predicate'
require 'scoruby/predicates/true_predicate'
require 'scoruby/predicates/false_predicate'

module Scoruby
  class PredicateFactory

    def self.for(pred_xml)
      return Predicates::SimplePredicate.new(pred_xml) if pred_xml.name == 'SimplePredicate'
      return Predicates::SimpleSetPredicate.new(pred_xml) if pred_xml.name == 'SimpleSetPredicate'
      return Predicates::CompoundPredicate.new(pred_xml) if pred_xml.name == 'CompoundPredicate'
      return Predicates::TruePredicate.new if pred_xml.name == 'True'
      return Predicates::FalsePredicate.new if pred_xml.name == 'False'
    end
  end
end

