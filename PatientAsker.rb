# Asks the user for valid input until it is provided.
class PatientAsker
  attr :options

  # options: hash of options:
  #   notify_invalid: message to display to users if they enter invalid input.
  def initialize(options=nil)
    @options = options ? Freezer.clone(options) : {}.freeze
    @notify_invalid = @options[:notify_invalid]
  end

  private def get_input(parser)
    print '> '
    parser.call(gets.chomp)
  end

  # Asks the user for input, then passes it to parser. If parser returns nil,
  # the value is considered invalid, and the user is asked for different input.
  # If parser does not return nil, its result is returned.
  def ask(&parser)
    until input = get_input(parser)
      puts @notify_invalid if @notify_invalid
    end
    puts
    input
  end
end
