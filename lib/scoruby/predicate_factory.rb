# frozen_string_literal: true

require 'scoruby/predicates/compound_predicate'
require 'scoruby/predicates/simple_predicate'
require 'scoruby/predicates/simple_set_predicate'
require 'scoruby/predicates/true_predicate'
require 'scoruby/predicates/false_predicate'

module Scoruby
  class PredicateFactory
    def self.for(pred_xml)
      return Predicates::TruePredicate.new if pred_xml.name == 'True'
      return Predicates::FalsePredicate.new if pred_xml.name == 'False'
      predicate = Object.const_get("Scoruby::Predicates::#{pred_xml.name}")
      predicate.new pred_xml
    end
  end
end
