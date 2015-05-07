# Encapsulates an option/action that the user may select.
class UserChoice
  # @value: the actual value associated with the action.
  # @label: the label shown to the user.
  attr :value, :label

  def initialize(value, label)
    @value = Freezer.clone(value)
    @label = Freezer.clone(label)
  end

  def to_s
    @label
  end
end
