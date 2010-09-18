class String
  def numeric?
    Float(self) rescue false
  end
end
