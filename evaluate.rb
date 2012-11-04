require 'minitest/autorun'
require 'pathname'
require 'debugger'

def constantize(word)
  name = word.split(/_/).collect(&:capitalize).join
  constant = Object
  constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
  constant
end

$extractors = []
Dir.glob('lib/*.rb').each do |src|
  require_relative src
  $extractors << Pathname.new(src).basename('.rb').to_s
  #$extractors << constantize(Pathname.new(src).basename('.rb').to_s)
end

class TestKeywords < MiniTest::Unit::TestCase

  def self.file_index(file_path)
    Pathname.new(file_path).basename('.txt')
  end

  $extractors.each do |impl|
    Dir.glob('samples/*.txt').each do |sample_file|
      define_method("#{impl}_#{file_index(sample_file)}") do
        @extractor = constantize(impl).new
        extract_keywords(sample_text(sample_file))
        check_missing_keywords
      end
    end
  end


  # def test_simple_keywords

  #   $extractors.each do |impl|
  #     @extractor = impl.new
  #     debugger
  #     Dir.glob('samples/*.txt').each do |sample_file|

  #       extract_keywords(sample_text(sample_file))
        
  #       check_missing_keywords
  #     end
  #   end
  # end

  private

  def extract_keywords(text)
    @keywords = @extractor.keywords(text)
    save_extracted
  end

  def sample_text(sample_file)
    @file_basename = Pathname.new(sample_file).basename
    File.read(sample_file)
  end

  def save_extracted
    File.open(actual_file, "w") do |out|
      out << @keywords.join("\n")
    end
  end

  def check_missing_keywords
    not_found = expected_keywords - @keywords
    assert_empty(not_found, "Keywords were not extracted by #{@extractor.class}")
  end

  def expected_keywords
    expected = File.readlines(keywords_file)
    expected.collect!(&:chomp)
    expected
  end
        
  def keywords_file
    File.join('keywords', @file_basename)
  end

  def actual_file
    File.join('actual', "#{@extractor.class}_#{@file_basename}")
  end
end
