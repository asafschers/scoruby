require 'numerical_predicate'
require 'categorical_predicate'

class Predicate

  attr_reader :decision

  def initialize(pred_xml)
    @pred_xml =  pred_xml.xpath('*')[0]
    @op = @pred_xml.xpath('@operator').to_s
    @bool_op = @pred_xml.xpath('@booleanOperator').to_s

    if !@op.empty?
      @pred = NumericalPredicate.new(@pred_xml)
    elsif !@bool_op.empty?
      @pred = CategoricalPredicate.new(@pred_xml)
    end

    @decision = pred_xml.xpath('@score').to_s
  end

  def to_s
    @pred_xml.to_s
  end

  def true?(features)
    return true if @pred.nil?
    @pred.true?(features)
  end
end