class FalsePredicate
  def field
    nil
  end

  def true?(_)
    false
  end
end