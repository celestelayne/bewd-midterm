# The set of U.S. states
class States
  attr :all

  # Cleans a state name or abbreviation for the lookup hashes.
  private def clean(s)
    s.downcase.strip.squeeze(' ')
  end

  def initialize(csv_name)
    @all = []
    @by_name   = {}
    @by_abbrev = {}
    CSV.foreach(csv_name,
      headers: true, header_converters: :symbol) do |row|
      state = State.new(row[:name], row[:abbreviation])
      all << state
      @by_name[clean(state.name)] = @by_abbrev[clean(state.abbrev)] = state
    end
    all.freeze
  end

  # Looks up a state by name.
  def by_name(name)
    @by_name[clean(name)]
  end

  # Looks up a state by abbreviation.
  def by_abbrev(abbrev)
    @by_abbrev[clean(abbrev)]
  end
end
