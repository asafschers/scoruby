require 'simple_predicate'
require 'simple_set_predicate'
require 'is_missing_predicate'

class Predicate

  def initialize(pred_xml)
    @pred = SimplePredicate.new(pred_xml) if pred_xml.name == 'SimplePredicate'
    @pred = SimpleSetPredicate.new(pred_xml) if pred_xml.name == 'SimpleSetPredicate'
  end

  def field
    @pred.field
  end

  def true?(features)
    return if missing_feature?(features)
    return if nil_feature?(features)
    @pred.true?(features)
  end

  def missing_feature?(features)
    return false if features.has_key? field
    RandomForester.logger.error "Missing feature #{field}"
    true
  end

  def nil_feature?(features)
    return false unless features[field].nil?
    RandomForester.logger.error "Feature #{field} value is nil"
    true
  end
end