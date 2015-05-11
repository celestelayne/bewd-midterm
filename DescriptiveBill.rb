# A Bill class with more attributes
class DescriptiveBill < Bill
  # @gpo_pdf: URL of the GPO PDF of the bill.
  attr :gpo_pdf, :num_cosponsors, :latest_major_action

  # json: JSON from bill details API:
  # http://api.nytimes.com/svc/politics/{version}/us/legislative/congress/{congress-number}/bills/{bill-id}[.response-format]?api-key={your-API-key}
  def initialize(json)
    @json = Freezer.clone(json)
    @number  = @json['bill']
    @title   = @json['title']
    @api_url = @json['bill_uri']
    @gpo_pdf = @json['gpo_pdf_uri']
    @num_cosponsors = @json['cosponsors'].to_i
    @latest_major_action = BillAction.new(@json['latest_major_action'],
      DateTime.parse(@json['latest_major_action_date']))
  end
end
