class PersonName
  def initialize first:, last:
    @first = first
    @last = last
  end

  def full
    [@first, @last].join ' '
  end
end
