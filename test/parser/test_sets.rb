require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserSets < Test::Unit::TestCase

  def test_parse_set_basic
    root = RP.parse('[a-c[:alpha:][:ascii:]]', 'ruby/1.9')
    #puts "root: #{root.inspect}"
    #pr root
  end

end
