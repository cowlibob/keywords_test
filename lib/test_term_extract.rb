# gem "term-extract", "~> 0.5.2"
require 'term-extract.rb'

class TestTermExtract
  def keywords(source)
    keywords = TermExtract.extract(source).keys.join(' ').downcase.split
    keywords
  end
end