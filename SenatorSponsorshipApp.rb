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

  def run
    about
    Senators.new(@builder).all.each { |senator| puts senator.name.full }
  end
end
