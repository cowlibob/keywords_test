# gem "term_extraction", "~> 0.1.7"
require 'term_extraction'

class TestTermExtractionZemanta
  def keywords(source)
    zemanta = TermExtraction::Zemanta.new(:api_key => 'myApiKey', :context => source)
    zemanta.terms # => ["Apple", "IMac", "Rumor", "Hardware", "Nvidia", "Macintosh", "Desktops", "AllInOne"]
  end
end