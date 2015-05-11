# An action taken on a bill
class BillAction
  attr :description, :datetime

  def initialize(description, datetime)
    @description = Freezer.clone(description)
    @datetime = datetime
  end
end
