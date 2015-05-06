class Senator
  attr :id, :name, :state, :party, :json

  def initialize(json)
    @json = Freezer.clone(json)
    @id = @json['id']
    @name = FullName.new(@json['first_name'], @json['middle_name'],
      @json['last_name'])
    @state = @json['state']
    @party = @json['party']
  end
end
