require 'glutton_ratelimit'
require 'json'
require 'rest-client'

require_relative 'Freezer.rb'
require_relative 'PatientAsker.rb'
require_relative 'ChoiceSolicitor.rb'
require_relative 'FullName.rb'
require_relative 'NYTRequestBuilder.rb'
require_relative 'NYTResponse.rb'
require_relative 'Senator.rb'
require_relative 'Senators.rb'
require_relative 'SenatorSponsorshipApp.rb'
require_relative 'State.rb'
require_relative 'UserChoice.rb'

# Read the API key from file.
key_file = File.open('api_key.txt')
key = key_file.each.next
key_file.close

SenatorSponsorshipApp.new(key).run
