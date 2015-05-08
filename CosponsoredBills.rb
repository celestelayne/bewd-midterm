# A set of a senator's cosponsored bills
class CosponsoredBills
  attr :all

  def initialize(senator, request_builder)
    @all = []
    url = "members/#{senator.id}/bills/cosponsored.json"
    request_builder.request(url).json['results'].first['bills'].each do |json|
      @all << CosponsoredBill.new(json)
    end
    all.freeze
  end
end
