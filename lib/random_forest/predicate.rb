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
    @pred.true?(features)
  end
end
