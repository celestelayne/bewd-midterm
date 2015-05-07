class SenatorSponsorshipApp
  def initialize(key)
    @builder = NYTRequestBuilder.new(
      category: 'politics',
      version:  3,
      append:   'us/legislative/congress',
      key:      key.dup,
      limit:    [2, 1]
    )
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
    puts method
    Senators.new(@builder).all.first
  end

  def run
    about
    senator = get_senator
    puts senator.name.full
  end
end
