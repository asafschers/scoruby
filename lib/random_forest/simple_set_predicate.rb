class SimpleSetPredicate

  IS_IN = 'isIn'

  attr_reader :field

  def initialize(pred_xml)
    attributes = pred_xml.attributes
    @field = attributes['field'].value.to_sym
    @array = single_or_quoted_words(pred_xml.children[0].content)
    @operator = attributes['booleanOperator'].value
  end

  def true?(features)
    format_boolean(features)
    @array.include? features[@field] if @operator == IS_IN
  end

  private

  def single_or_quoted_words(string)
    string.split(/\s(?=(?:[^"]|"[^"]*")*$)/).
        reject(&:empty?).
        map { |w| w.tr('"','')}
  end

  def format_boolean(features)
    features[@field] = 'f' if features[@field] == false
    features[@field] = 't' if features[@field] == true
  end
end