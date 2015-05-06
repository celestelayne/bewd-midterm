class FullName
  attr :first, :middle, :last, :full, :first_last

  def initialize(first, middle, last)
    @first  = Freezer.clone(first)
    @middle = Freezer.clone(middle)
    @last   = Freezer.clone(last)

    @full = "#{first} #{middle} #{last}"
    @first_last = "#{first} #{last}"
    [full, first_last].each { |name| name.squeeze!(' ').freeze }
  end
end
