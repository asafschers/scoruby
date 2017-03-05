require 'numerical_predicate'
require 'categorical_predicate'

class Node

  attr_reader :decision, :left, :right, :pred

  def initialize(xml)
    children = xml.children
    @pred_xml = children[0]
    @op = @pred_xml.attribute('operator')
    @bool_op = @pred_xml.attribute('booleanOperator')

    if !@op.nil?
      @pred = NumericalPredicate.new(@pred_xml)
    elsif !@bool_op.nil?
      @pred = CategoricalPredicate.new(@pred_xml)
    end

    @decision = xml.attribute('score').to_s

    return if children.count == 1
    @left = Node.new(children[1]) if children[1]
    @right = Node.new(children[2]) if children[2]
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