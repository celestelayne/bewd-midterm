require 'csv'
require 'glutton_ratelimit'
require 'json'
require 'rest-client'
require 'set'

require_relative 'Bill.rb'
require_relative 'Freezer.rb'
require_relative 'CosponsoredBill.rb'
require_relative 'CosponsoredBills.rb'
require_relative 'PatientAsker.rb'
require_relative 'ChoiceSolicitor.rb'
require_relative 'FullName.rb'
require_relative 'NYTRequestBuilder.rb'
require_relative 'NYTResponse.rb'
require_relative 'Senator.rb'
require_relative 'SenatorLookup.rb'
require_relative 'UserChoice.rb'
require_relative 'SenatorLookupByName.rb'
require_relative 'SenatorLookupByState.rb'
require_relative 'SenatorSponsorshipApp.rb'
require_relative 'Senators.rb'
require_relative 'SenatorsByName.rb'
require_relative 'State.rb'
require_relative 'States.rb'

SenatorSponsorshipApp.new('api_key.txt', 'states.csv').run
