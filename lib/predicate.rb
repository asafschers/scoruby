require 'numerical_predicate'
require 'categorical_predicate'

class Predicate

  attr_reader :decision

  def initialize(pred_xml, decision)
    @pred_xml = pred_xml

    @op = @pred_xml.attribute('operator').to_s
    @bool_op = @pred_xml.attribute('booleanOperator').to_s

    if !@op.empty?
      @pred = NumericalPredicate.new(@pred_xml)
    elsif !@bool_op.empty?
      @pred = CategoricalPredicate.new(@pred_xml)
    end

    @decision = decision
  end

  def to_s
    @pred_xml.to_s
  end

  def field
    @pred.field
  end

  def true?(features)
    return true if @pred.nil?
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