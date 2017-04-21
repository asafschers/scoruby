require 'simple_predicate'
require 'simple_set_predicate'

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
    Scoruby.logger.error "Missing feature #{field}"
    true
  end

  def nil_feature?(features)
    return false unless features[field].nil?
    Scoruby.logger.error "Feature #{field} value is nil"
    true
  end
end