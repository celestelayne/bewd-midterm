# A set of senators
class Senators
  attr :all

  def initialize(request_builder, states)
    @all = []
    # The session of Congress:
    # http://www.senate.gov/pagelayout/reference/one_item_and_teasers/Years_to_Congress.htm
    session = (Time.now.year - 1787) / 2
    url = "#{session}/senate/members/current.json"
    request_builder.request(url).json['results'].first['members'].each do |json|
      all << Senator.new(json, states)
    end
    all.freeze
  end
end
