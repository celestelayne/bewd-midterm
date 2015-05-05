# JSON response from the New York Times API
class NYTResponse
  attr :url, :json

  def initialize(url)
    @url = Freezer.clone(url)

    response = RestClient.get(url)
    @json = Freezer.freeze(JSON.load(response))
  end
end
