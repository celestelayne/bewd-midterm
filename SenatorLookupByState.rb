class SenatorLookupByState < SenatorLookup
  attr :states

  STATE_ASKER = PatientAsker.new(
    notify_invalid: "I don't know that state. Won't you try again?"
  )
  private_constant :STATE_ASKER

  def initialize(senators, states)
    @senators = senators
    @states   = states
  end

  def lookup
    puts 'Which state?'
    state = STATE_ASKER.ask do |s|
      (state = states.by_abbrev(s)) ? state : states.by_name(s)
    end

    puts 'Which senator?'
    senator_choices = senators.all.select { |senator| senator.state == state }.
      map! { |senator| UserChoice.new(senator, senator.name.full) }.
      sort_by! { |choice| choice.label }
    ChoiceSolicitor.new(senator_choices).solicit.value
  end
end
