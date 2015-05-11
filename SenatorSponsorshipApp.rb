class SenatorSponsorshipApp
  EXIT = :exit
  private_constant :EXIT

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

  private def date_string(date)
    date.strftime('%-m/%-d/%Y')
  end

  private def get_bill_solicitor(bills, number_to_show)
    choices = []
    i = 0
    sorted = bills.all.sort_by { |bill| -bill.cosponsored_date.to_time.to_i }
    sorted.each do |bill|
      break if (i += 1) > number_to_show
      # Some but not all bill titles end in a period.
      period = bill.title =~ /\.$/ ? '' : '.'
      date = date_string(bill.cosponsored_date)
      label = "#{bill.number}: #{bill.title}#{period} (Cosponsored on #{date}.)"
      choices << UserChoice.new(bill, label)
    end
    choices << UserChoice.new(EXIT, 'EXIT APP')
    ChoiceSolicitor.new(choices)
  end

  private def get_bill_choice(solicitor, senator)
    puts "Below are some of Senator #{senator.name.last}'s recently cosponsored"
    puts "bills."
    puts
    puts "Choose one to learn more."
    puts
    solicitor.solicit.value
  end

  private def describe_bill(bill)
    json = @builder.request(bill.api_url).json['results'].first
    descriptive = DescriptiveBill.new(json)

    puts "#{descriptive.number}: #{descriptive.title}"
    puts "Number of cosponsors: #{descriptive.num_cosponsors}"
    puts
    date = date_string(descriptive.latest_major_action.datetime)
    puts "Latest major action (#{date}):"
    puts descriptive.latest_major_action.description
    puts
    puts "PDF URL:"
    puts descriptive.gpo_pdf
    puts
    puts 'Press enter to continue.'
    gets.chomp
  end

  private def farewell
    puts 'Come again!'
    puts
  end

  def run
    about

    senator = get_senator
    bills = CosponsoredBills.new(senator, @builder)
    if bills.all.size == 0
      puts 'That senator has no recently cosponsored bills. :('
      puts
    else
      solicitor = get_bill_solicitor(bills, 10)
      until (choice = get_bill_choice(solicitor, senator)) == EXIT
        describe_bill choice
      end
    end

    farewell
  end
end
