class CosponsoredBill < Bill
  attr :cosponsored_date

  def initialize(json)
    @json = Freezer.clone(json)
    @number  = @json['number']
    @title   = @json['title']
    @api_url = @json['bill_uri']
    @cosponsored_date = Date.parse(@json['cosponsored_date'])
  end
end
