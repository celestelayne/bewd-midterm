class SenatorSponsorshipApp
  # Reads the API key from file.
  private def read_key_from_file(filename)
    key_file = File.open(filename)
    key = key_file.each.next
    key_file.close
    key
  end

  # key_file: name of the file that contains the API key.
  # states_csv: name of a .csv file of state names and abbreviations.
  def initialize(key_file, states_csv)
    @builder = NYTRequestBuilder.new(
      category: 'politics',
      version:  3,
      append:   'us/legislative/congress',
      key:      read_key_from_file(key_file),
      limit:    [2, 1]
    )
    @states = States.new(states_csv)
    @senators = Senators.new(@builder, @states)
  end

  private def about
    puts
    puts "Welcome to the Senator Sponsorship App!"
    puts "(Data provided by The New York Times.)"
    puts
    puts "You tell us a senator, and we'll tell you which bills the senator has"
    puts "recently cosponsored."
    puts
  end

  private def get_senator
    puts 'How would you like to select a senator?'
    method = ChoiceSolicitor.new([
        UserChoice.new(:by_name,  'By name'),
        UserChoice.new(:by_state, 'By state')
      ]).solicit.value
    lookup = case method
    when :by_name
      SenatorLookupByName.new(@senators)
    when :by_state
      SenatorLookupByState.new(@senators, @states)
    else
      raise 'unreachable code'
    end
    lookup.lookup
  end

  def run
    about
    senator = get_senator
    puts senator.name.full
  end
end
