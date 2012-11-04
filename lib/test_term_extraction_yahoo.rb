# gem "term_extraction", "~> 0.1.7"
require 'term_extraction'

class TestTermExtractionYahoo
  def keywords(source)
    yahoo = TermExtraction::Yahoo.new(:api_key => 'myApiKey', :context => source)
    [yahoo.terms].flatten # => ["gears of war", "xbox 360", "gears", "xbox"]
  end
end