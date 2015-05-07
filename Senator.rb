class Senator
  attr :id, :name, :state, :party, :json

  def initialize(json, states)
    @json = Freezer.clone(json)
    @id = @json['id']
    @name = FullName.new(@json['first_name'], @json['middle_name'],
      @json['last_name'])
    @state = states.by_abbrev(@json['state']) or raise 'unknown state'
    @party = @json['party']
  end
end
