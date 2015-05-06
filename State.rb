# A U.S. state
class State
  # @abbrev: two-letter state abbreviation
  attr :name, :abbrev

  def initialize(name, abbrev)
    @name = Freezer.clone(name)
    abbrev =~ /^..$/ or raise 'invalid abbreviation'
    @abbrev = Freezer.clone(abbrev)
  end

  def ==(other)
    return false unless other.is_a? State
    name == other.name && abbrev == other.abbrev
  end

  alias_method :eql?, :==
end
