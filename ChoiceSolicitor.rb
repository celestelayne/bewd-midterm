# Presents users with several options and returns their selection.
class ChoiceSolicitor
  ASKER = PatientAsker.new(
    notify_invalid: "Oops! That's not a valid choice.\n" +
      "I'm sorry about that. Won't you choose again?"
  )
  private_constant :ASKER

  attr :choices

  # choices: the list of UserChoice objects to present to the user.
  def initialize(choices)
    @choices = Freezer.clone(choices)
  end

  def solicit
    i = 0
    choices.each { |choice| puts "[#{i += 1}] #{choice}" }
    puts
    ASKER.ask &->(choice) do
      choice_f = choice.to_f
      # If choice is not a number, choice_f is 0, and nil is returned.
      return nil if choice_f < 1 || choice_f > choices.size
      choice_i = choice_f.to_i
      return nil unless choice_i == choice_f

      # Make choice_i indexed at 0.
      # (Humans and computers have different preferences on this one.)
      choice_i -= 1
      choices[choice_i]
    end
  end
end
