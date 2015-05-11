# Facilitates the creation of requests to the New York Times API
class NYTRequestBuilder
  # @category: the name of the API of interest, e.g., 'politics'.
  # @version: the API version.
  # @append (optional): path elements to append to the base request URL.
  # @base: the base request URL:
  #   http://api.nytimes.com/svc/@category/v@version/@append/
  # @key: the API key.
  # @limit: the API rate limit as an array:
  #   [number_of_calls, timeframe_in_seconds]. For instance, [2, 1] means
  #   "two calls per second."
  attr :category, :version, :append, :base, :key, :limit

  def initialize(options)
    # Check that required options were specified.
    [:category, :version, :key, :limit].each do |option|
      options.has_key?(option) or raise "option #{option} required"
    end

    @category = Freezer.clone(options[:category])
    @version  = Freezer.clone(options[:version])
    @key      = Freezer.clone(options[:key])
    @limit    = Freezer.clone(options[:limit])

    if @append = options[:append]
      @append = append.dup
      append << '/' unless append =~ /\/$/
      append.freeze
    end

    @base = "http://api.nytimes.com/svc/#{category}/v#{version}/"
    base << append if append
    base.freeze

    @limiter = GluttonRatelimit::BurstyTokenBucket.new(limit[0], limit[1])
  end

  # url: the remainder of the request URL after the base URL.
  def request(url)
    # Allow the user to specify the full URL.
    remainder = url[0, base.length] == base ? url.sub(base, '') : url

    request = nil
    delim = remainder.include?('?') ? '&' : '?'
    @limiter.times 1 do
      request = NYTResponse.new("#{base}#{remainder}#{delim}api-key=#{key}")
    end
    request
  end
end
