class SenatorLookupByName < SenatorLookup
  NAME_ASKER = PatientAsker.new(
    notify_invalid: "I don't know which senator that is. Won't you try again?"
  )
  YES_NO_SOLICITOR = ChoiceSolicitor.new([
    UserChoice.new(true,  'Yes'),
    UserChoice.new(false, 'No')
  ])
  private_constant :NAME_ASKER, :YES_NO_SOLICITOR

  def initialize(senators)
    @senators = SenatorsByName.new(senators)
  end

  # Asks the user for a name that matches a single senator, then returns
  # that senator.
  private def match_name
    puts 'What is the name of the senator?'
    puts 'Enter a first name, last name, or full name.'
    puts 'If entering a full name, type the first name first.'
    puts
    NAME_ASKER.ask { |name| senators.by_name(name) }
  end

  # Confirms with users that they intended to select a given senator.
  private def confirm(senator)
    puts "Senator #{senator.name.full} matches that name!"
    puts "Is this who you meant?"
    puts
    YES_NO_SOLICITOR.solicit.value
  end

  def lookup
    senator = nil
    loop do
      senator = match_name
      break if confirm(senator)
    end
    senator
  end
end
