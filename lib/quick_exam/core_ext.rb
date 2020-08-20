class Object
  def __blank?
    case self
    when [], '', "\n", nil, false
      true
    else
      false
    end
  end

  def __present?
    !__blank?
  end

  def __presence
    self if __present?
  end
end
