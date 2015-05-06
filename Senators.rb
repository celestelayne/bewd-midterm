# A set of senators
class Senators
  attr :all, :state

  def initialize(request_builder, state=nil)
    @state = state

    @all = []
    # The session of Congress:
    # http://www.senate.gov/pagelayout/reference/one_item_and_teasers/Years_to_Congress.htm
    session = (Time.now.year - 1787) / 2
    url = "#{session}/senate/members/current.json"
    url << "?state=#{state.abbrev}" if state
    request_builder.request(url).json['results'].first['members'].each do |json|
      all << Senator.new(json)
    end
    all.freeze
  end
end
