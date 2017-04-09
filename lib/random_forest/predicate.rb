require 'numerical_predicate'
require 'categorical_predicate'
require 'is_missing_predicate'

class Predicate

  def initialize(pred_xml)
    attributes = pred_xml.attributes

    # TODO: extract method set_pred
    @pred = IsMissingPredicate.new(attributes) if attributes['operator'] && attributes['operator'].value == 'isMissing'
    @pred = NumericalPredicate.new(attributes) if attributes['operator'] && attributes['operator'].value != 'isMissing'
    @pred = CategoricalPredicate.new(pred_xml) if attributes['booleanOperator']
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